#!/usr/bin/env bash
# Pick the webcam Howdy should use, without hard-coding one machine's device.
#
# Howdy takes a fixed path in [video] device_path. A /dev/v4l/by-id path is
# stable across reboots and USB ports, but it embeds the device's USB serial,
# so committing it bakes one machine into the dotfiles. This resolves it at
# install time instead: by-id -> by-path -> /dev/videoN, preferring the
# capture node (UVC exposes a second, metadata-only node with index 1).
#
#   howdy-camera.sh                     print the device that would be chosen
#   howdy-camera.sh --list              list every capture-capable node
#   howdy-camera.sh --set               write it into /etc/howdy/config.ini
#   howdy-camera.sh --set --config X    ...into an explicit config file
#   howdy-camera.sh --device /dev/video2
#
# Override detection with HOWDY_DEVICE or --device.
set -euo pipefail

config=/etc/howdy/config.ini
mode=print
forced=${HOWDY_DEVICE:-}

usage() { sed -n '3,19p' "$0" | sed 's/^# \{0,1\}//'; }
die() { printf 'howdy-camera: %s\n' "$*" >&2; exit 1; }

while [ $# -gt 0 ]; do
	case $1 in
		--list)   mode=list ;;
		--set)    mode=set ;;
		--device) [ $# -ge 2 ] || die "--device needs an argument"; forced=$2; shift ;;
		--config) [ $# -ge 2 ] || die "--config needs an argument"; config=$2; shift ;;
		-h|--help) usage; exit 0 ;;
		*) die "unknown option: $1 (try --help)" ;;
	esac
	shift
done

# Only nodes that can actually capture frames are useful: index 0 is the
# capture node, index 1 is the UVC metadata node.
is_capture() {
	local node index
	node=$(readlink -f "$1" 2>/dev/null) || return 1
	node=${node##*/}
	index=$(cat "/sys/class/video4linux/$node/index" 2>/dev/null || echo 0)
	[ "$index" = 0 ]
}

device_name() {
	local node
	node=${1##*/}
	cat "/sys/class/video4linux/$node/name" 2>/dev/null || echo unknown
}

# Stable path for a node: by-id first (survives port changes), then by-path
# (survives re-enumeration but not a different port), else the raw node.
stable_path() {
	local real link
	real=$(readlink -f "$1")
	for link in /dev/v4l/by-id/*-video-index0 /dev/v4l/by-path/*-video-index0; do
		[ -e "$link" ] || continue
		[ "$(readlink -f "$link")" = "$real" ] && { printf '%s\n' "$link"; return; }
	done
	printf '%s\n' "$1"
}

if [ -n "$forced" ]; then
	[ -e "$forced" ] || die "device does not exist: $forced"
	is_capture "$forced" || die "$forced is not a capture node (metadata node?)"
	candidates=("$(stable_path "$forced")")
else
	candidates=()
	while IFS= read -r dev; do
		is_capture "$dev" && candidates+=("$(stable_path "$dev")")
	done < <(ls -1 /dev/video* 2>/dev/null | sort -V)
fi

[ ${#candidates[@]} -gt 0 ] || die "no capture-capable /dev/video* found (camera unplugged?)"

if [ "$mode" = list ]; then
	printf '%-58s %-28s %s\n' DEVICE NAME NODE
	for c in "${candidates[@]}"; do
		printf '%-58s %-28s %s\n' "$c" "$(device_name "$(readlink -f "$c")")" "$(readlink -f "$c")"
	done
	exit 0
fi

device=${candidates[0]}
if [ ${#candidates[@]} -gt 1 ]; then
	printf 'howdy-camera: %d cameras found, using the first (pick one with --device)\n' "${#candidates[@]}" >&2
	for c in "${candidates[@]}"; do printf '  %s\n' "$c" >&2; done
fi

if [ "$mode" = print ]; then
	printf '%s\n' "$device"
	exit 0
fi

# --set: rewrite only the device_path line, keeping comments and layout
# (configparser would drop every comment in the file).
set +e
py_out=$(python3 - "$config" "$device" <<'PY'
import os, re, sys

path, device = sys.argv[1], sys.argv[2]
if not os.path.isfile(path):
    sys.exit(f"howdy-camera: no config at {path}")
if not os.access(path, os.W_OK):
    sys.exit(f"howdy-camera: {path} is not writable (run with sudo, or symlink it into ~/.dotfiles)")

lines = open(path).read().split("\n")
start = next((i for i, l in enumerate(lines) if re.match(r"^\s*\[video\]\s*$", l)), None)
if start is None:
    start = len(lines)
    lines += ["[video]"]
end = next((i for i in range(start + 1, len(lines)) if re.match(r"^\s*\[.+\]\s*$", lines[i])), len(lines))

line = next((i for i in range(start + 1, end) if re.match(r"^\s*device_path\s*=", lines[i])), None)
if line is not None and re.match(rf"^\s*device_path\s*=\s*{re.escape(device)}\s*$", lines[line]):
    print(f"device_path already set to {device}")
    sys.exit(3)

if line is None:
    lines.insert(end, f"device_path = {device}")
else:
    lines[line] = re.sub(r"^(\s*device_path\s*=\s*).*$", lambda m: m.group(1) + device, lines[line])

open(path, "w").write("\n".join(lines))
print(f"device_path = {device}")
PY
)
rc=$?
set -e

[ -n "$py_out" ] && printf '%s\n' "$py_out"
case $rc in
	0) printf 'howdy-camera: %s updated; pam_howdy reads it as root on the next auth\n' "$config" ;;
	3) printf 'howdy-camera: %s unchanged\n' "$config" ;;
	*) exit "$rc" ;;
esac
