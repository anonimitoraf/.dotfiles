#!/usr/bin/env bash
# plugins/aerospace.sh <workspace-id>
# Draws a single AeroSpace workspace item. Called by SketchyBar for each
# space.<id> item on the events it subscribes to.
#
# Rules:
#   - Show the item only if the workspace contains windows OR is focused.
#   - Highlight the focused workspace (white text on a lifted background).
#
# $1                       = the workspace id this item represents (from script arg)
# $FOCUSED_WORKSPACE       = set by aerospace's exec-on-workspace-change callback
# $NAME                    = sketchybar item name (space.<id>)

sid="$1"

# Which workspace is focused right now. Prefer the env var the callback passes;
# fall back to querying aerospace directly (e.g. on front_app_switched events).
focused="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

# Does this workspace have any windows?
has_windows=$(aerospace list-windows --workspace "$sid" --count 2>/dev/null)
[ -z "$has_windows" ] && has_windows=0

if [ "$sid" = "$focused" ]; then
    # Focused: always visible, highlighted (white on lifted bg — mirrors i3 focus).
    sketchybar --set "$NAME" \
        drawing=on \
        background.drawing=on \
        background.color=0xff3f3f3f \
        icon.color=0xffffffff
elif [ "$has_windows" -gt 0 ]; then
    # Filled but not focused: visible, dimmed.
    sketchybar --set "$NAME" \
        drawing=on \
        background.drawing=off \
        icon.color=0xffc6c6c6
else
    # Empty and unfocused: hide entirely.
    sketchybar --set "$NAME" drawing=off
fi
