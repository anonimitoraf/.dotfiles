/**
 * Context progress bar footer.
 *
 * Owns the footer and renders the context usage as a progress bar of
 * used / total tokens instead of a bare percentage:
 *
 *   ⎇ main [███████░░░] 42.0% 84k/200k (auto) ↑12k ↓3.4k R55k $0.42   MCP 3/3 med
 *
 * pi-powerline's footer is disabled in ~/.pi/agent/settings.json ("footer": false)
 * so only one extension sets the footer. Everything the powerline footer showed
 * (git branch, token stats, cache hit rate, cost, MCP status, think level) is kept.
 *
 * Commands:
 *   /ctxbar              toggle bar <-> plain percentage
 *   /ctxbar on|off       set it explicitly
 *   /ctxbar width:<3-24> bar width in cells
 */

import type { AssistantMessage } from "@earendil-works/pi-ai";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import { existsSync, readFileSync } from "node:fs";
import { join } from "node:path";

// ═══════════════════════════════════════════════════════════════════════════
// tuning
// ═══════════════════════════════════════════════════════════════════════════

const ICON_GIT = "⎇";
const FILLED = "█";
const EMPTY = "░";
const MIN_BAR = 3;
const MAX_BAR = 24;

const THINK_LABELS: Record<string, string> = {
	minimal: "min",
	low: "low",
	medium: "med",
	high: "high",
	xhigh: "xhi",
	max: "max",
};

const THINK_COLORS: Record<string, string> = {
	minimal: "thinkingMinimal",
	low: "thinkingLow",
	medium: "thinkingMedium",
	high: "thinkingHigh",
	xhigh: "thinkingXhigh",
	max: "thinkingMax",
};

// ═══════════════════════════════════════════════════════════════════════════
// live state
// ═══════════════════════════════════════════════════════════════════════════

let showBar = true;
let barCells = 10;
let enabled = false;
let liveTui: { requestRender(): void } | null = null;
let isStreaming = false;
let liveUsage: AssistantMessage["usage"] | null = null;
let thinkLevel = "off";
let autoCompact = true;

// ═══════════════════════════════════════════════════════════════════════════
// helpers
// ═══════════════════════════════════════════════════════════════════════════

function formatTokens(count: number): string {
	if (count < 1000) return String(count);
	if (count < 10_000) return `${(count / 1000).toFixed(1)}k`;
	if (count < 1_000_000) return `${Math.round(count / 1000)}k`;
	if (count < 10_000_000) return `${(count / 1_000_000).toFixed(1)}M`;
	return `${Math.round(count / 1_000_000)}M`;
}

function usageTotal(usage: AssistantMessage["usage"]): number {
	const total = (usage as { totalTokens?: number }).totalTokens;
	if (typeof total === "number" && total > 0) return total;
	return usage.input + usage.output + usage.cacheRead + usage.cacheWrite;
}

/** Bar width for the current terminal, shrinking on narrow layouts. */
function barCellCount(width: number): number {
	const cap = width < 50 ? 4 : width < 70 ? 6 : width < 90 ? 8 : barCells;
	return Math.max(MIN_BAR, Math.min(MAX_BAR, Math.min(cap, barCells)));
}

function contextColor(percent: number): string {
	if (percent > 90) return "error";
	if (percent > 70) return "warning";
	return "success";
}

/** Progress bar as { plain, colored }: plain is used for width math. */
function renderBar(percent: number, cells: number, theme: any): { plain: string; colored: string } {
	const ratio = Number.isFinite(percent) ? Math.max(0, Math.min(100, percent)) : 0;
	const filled = Math.round((ratio / 100) * cells);
	const empty = cells - filled;
	const plain = `[${FILLED.repeat(filled)}${EMPTY.repeat(empty)}]`;
	const colored =
		`[${theme.fg(contextColor(percent), FILLED.repeat(filled))}` +
		`${theme.fg("dim", EMPTY.repeat(empty))}]`;
	return { plain, colored };
}

function sanitizeStatusText(text: string): string {
	return text
		.replace(/[\r\n\t]/g, " ")
		.replace(/ +/g, " ")
		.trim();
}

/** Auto-compaction lives under `compaction.enabled` in the project settings file. */
function readAutoCompactEnabled(cwd: string): boolean {
	const path = join(cwd, ".pi", "settings.json");
	if (!existsSync(path)) return true;
	try {
		const settings = JSON.parse(readFileSync(path, "utf-8") || "{}");
		const compaction = settings?.compaction;
		if (compaction && typeof compaction === "object" && "enabled" in compaction) {
			return !!compaction.enabled;
		}
	} catch {
		// ignore unreadable settings
	}
	return true;
}

function lastAssistantUsage(ctx: ExtensionContext): AssistantMessage["usage"] | undefined {
	let latest: AssistantMessage["usage"] | undefined;
	for (const entry of ctx.sessionManager.getEntries()) {
		if (entry.type !== "message" || entry.message.role !== "assistant") continue;
		const message = entry.message as AssistantMessage;
		if (message.stopReason === "error" || message.stopReason === "aborted") continue;
		if (usageTotal(message.usage) > 0) latest = message.usage;
	}
	return latest;
}

// ═══════════════════════════════════════════════════════════════════════════
// footer
// ═══════════════════════════════════════════════════════════════════════════

function createFooter(ctx: ExtensionContext) {
	return (tui: any, theme: any, footerData: any) => {
		liveTui = tui;
		const unsubscribe = footerData.onBranchChange(() => tui.requestRender());

		return {
			dispose() {
				liveTui = null;
				unsubscribe();
			},
			invalidate() {},
			render(width: number): string[] {
				// ── context usage: live stream wins, then core, then last persisted ──
				const core = isStreaming && liveUsage ? undefined : ctx.getContextUsage();
				const fallbackUsage = liveUsage ?? lastAssistantUsage(ctx);
				const tokens = core?.tokens ?? (fallbackUsage ? usageTotal(fallbackUsage) : null);
				const contextWindow = core?.contextWindow ?? ctx.model?.contextWindow ?? 0;
				const percent =
					tokens !== null && contextWindow > 0 ? (tokens / contextWindow) * 100 : NaN;

				// ── stats parts, bar first ──
				const percentText = Number.isFinite(percent) ? `${percent.toFixed(1)}%` : "?";
				const usedText = tokens !== null ? formatTokens(tokens) : "?";
				const ratioText = `${percentText} ${usedText}/${formatTokens(contextWindow)}${autoCompact ? " (auto)" : ""}`;
				const ratioColored = theme.fg(contextColor(percent), ratioText);

				// ── cumulative token stats ──
				let input = 0,
					output = 0,
					cacheRead = 0,
					cacheWrite = 0,
					cost = 0;
				for (const entry of ctx.sessionManager.getEntries()) {
					if (entry.type !== "message" || entry.message.role !== "assistant") continue;
					const message = entry.message as AssistantMessage;
					if (message.stopReason === "error" || message.stopReason === "aborted") continue;
					input += message.usage.input;
					output += message.usage.output;
					cacheRead += message.usage.cacheRead;
					cacheWrite += message.usage.cacheWrite;
					cost += message.usage.cost.total;
				}
				if (isStreaming && liveUsage) {
					input += liveUsage.input;
					output += liveUsage.output;
					cacheRead += liveUsage.cacheRead;
					cacheWrite += liveUsage.cacheWrite;
					cost += liveUsage.cost.total;
				}

				const tokenParts: string[] = [];
				if (input) tokenParts.push(`↑${formatTokens(input)}`);
				if (output) tokenParts.push(`↓${formatTokens(output)}`);
				if (cacheRead) tokenParts.push(`R${formatTokens(cacheRead)}`);
				if (cacheWrite) tokenParts.push(`W${formatTokens(cacheWrite)}`);
				const hitRate = liveUsage ?? fallbackUsage;
				if (hitRate) {
					const prompt = hitRate.input + hitRate.cacheRead + hitRate.cacheWrite;
					if (prompt > 0 && (cacheRead > 0 || cacheWrite > 0)) {
						tokenParts.push(`CH${((hitRate.cacheRead / prompt) * 100).toFixed(1)}%`);
					}
				}
				if (cost) tokenParts.push(`$${cost.toFixed(3)}`);
				const tokenText = tokenParts.join(" ");
				const tokenColored = tokenText ? theme.fg("dim", tokenText) : "";

				// ── left side: git branch + stats, built with and without the bar ──
				const branch = footerData.getGitBranch() as string | null;
				const branchText = branch ? `${ICON_GIT} ${branch}` : "";
				const branchPrefixWidth = branch ? visibleWidth(branchText) + 1 : 0;

				// the bar is the first thing to give when the line gets tight: shrink, then drop
				const buildLeft = (cells: number) => {
					const bitsPlain: string[] = [];
					const bitsColored: string[] = [];
					if (cells > 0) {
						const bar = renderBar(percent, cells, theme);
						bitsPlain.push(bar.plain);
						bitsColored.push(bar.colored);
					}
					bitsPlain.push(ratioText);
					bitsColored.push(ratioColored);
					if (tokenText) {
						bitsPlain.push(tokenText);
						bitsColored.push(tokenColored);
					}
					const plain = bitsPlain.join(" ");
					const colored = branch
						? `${theme.fg("success", branchText)} ${bitsColored.join(" ")}`
						: bitsColored.join(" ");
					return { plain, colored, width: branchPrefixWidth + visibleWidth(plain) };
				};

				// ── right side: MCP status, then think level, then nothing ──
				const statuses = footerData.getExtensionStatuses() as Map<string, string>;
				const mcp = sanitizeStatusText(statuses.get("mcp") ?? "");
				const thinkPlain = ctx.model?.reasoning ? THINK_LABELS[thinkLevel] ?? thinkLevel : "";
				const thinkColored = thinkPlain
					? theme.fg(THINK_COLORS[thinkLevel] ?? "thinkingOff", thinkPlain)
					: "";

				const rightCandidates = [
					{ plain: [mcp, thinkPlain].filter(Boolean).join(" "), colored: [mcp, thinkColored].filter(Boolean).join(" ") },
					{ plain: thinkPlain, colored: thinkColored },
					{ plain: "", colored: "" },
				]
					.map((candidate) => ({ ...candidate, width: visibleWidth(candidate.plain) }))
					.filter((candidate, index, all) => candidate.width > 0 || index === all.length - 1);

				// Degrade: wide bar -> narrower bar -> no bar -> truncate.
				const minPad = 2;
				const barSizes = [...new Set([barCellCount(width), 6, 4, 0])]
					.filter((cells) => cells <= barCells)
					.sort((a, b) => b - a);
				let line = "";
				for (const cells of showBar ? barSizes : [0]) {
					const left = buildLeft(cells);
					const right = rightCandidates.find(
						(candidate) => left.width + minPad + candidate.width <= width,
					);
					if (right) {
						const pad = " ".repeat(Math.max(0, width - left.width - right.width));
						line = `${left.colored}${theme.fg("dim", pad)}${right.colored}`;
						break;
					}
					if (left.width <= width) {
						line = left.colored;
						break;
					}
				}
				if (!line) {
					line = truncateToWidth(buildLeft(0).colored, width, "...");
				}

				const lines = [line];

				// ── extra extension statuses (everything except MCP, which is fused) ──
				const rest = Array.from(statuses.entries())
					.filter(([key]) => key !== "mcp")
					.sort(([a], [b]) => a.localeCompare(b))
					.map(([, text]) => sanitizeStatusText(text))
					.filter(Boolean);
				if (rest.length) {
					lines.push(truncateToWidth(theme.fg("dim", rest.join(" ")), width, "..."));
				}

				return lines;
			},
		};
	};
}

// ═══════════════════════════════════════════════════════════════════════════
// registration
// ═══════════════════════════════════════════════════════════════════════════

export default function (pi: ExtensionAPI) {
	function enable(ctx: ExtensionContext) {
		enabled = true;
		thinkLevel = pi.getThinkingLevel();
		ctx.ui.setFooter(createFooter(ctx) as any);
	}

	pi.on("session_start", (_event, ctx) => {
		autoCompact = readAutoCompactEnabled(ctx.cwd);
		enable(ctx);
	});

	pi.on("model_select", (_event, ctx) => {
		thinkLevel = pi.getThinkingLevel();
		if (!enabled) enable(ctx);
		else liveTui?.requestRender();
	});

	pi.on("thinking_level_select", (event) => {
		thinkLevel = event.level;
		liveTui?.requestRender();
	});

	pi.on("agent_start", () => {
		isStreaming = true;
		liveUsage = null;
	});

	pi.on("message_update", (event) => {
		const message = event.message as AssistantMessage;
		if (message?.role !== "assistant" || typeof message.usage?.input !== "number") return;
		liveUsage = message.usage;
		liveTui?.requestRender();
	});

	pi.on("message_end", (event) => {
		isStreaming = false;
		const message = event.message as AssistantMessage;
		liveUsage =
			message?.role === "assistant" &&
			message.stopReason !== "error" &&
			message.stopReason !== "aborted"
				? message.usage
				: null;
		liveTui?.requestRender();
	});

	pi.registerCommand("ctxbar", {
		description: "Toggle or resize the context progress bar (/ctxbar on|off|width:N)",
		handler: async (args, ctx) => {
			const arg = (args ?? "").trim().toLowerCase();
			if (arg === "on" || arg === "off") {
				showBar = arg === "on";
			} else if (arg.startsWith("width:")) {
				const value = Number.parseInt(arg.slice("width:".length), 10);
				if (!Number.isFinite(value) || value < MIN_BAR || value > MAX_BAR) {
					ctx.ui.notify(`width must be ${MIN_BAR}-${MAX_BAR}`, "warning");
					return;
				}
				barCells = value;
				showBar = true;
			} else if (arg === "") {
				showBar = !showBar;
			} else {
				ctx.ui.notify("Usage: /ctxbar [on|off|width:N]", "warning");
				return;
			}
			liveTui?.requestRender();
			ctx.ui.notify(`ctxbar → ${showBar ? `on (${barCells} cells)` : "off"}`, "info");
		},
	});
}
