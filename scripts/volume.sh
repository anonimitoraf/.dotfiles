#!/usr/bin/env bash
#
# volume.sh - change the default sink volume and show a notification with the
# resulting volume level.
#
# Usage:
#   volume.sh up   [step]   raise volume by <step> percent (default: 5)
#   volume.sh down [step]   lower volume by <step> percent (default: 5)
#   volume.sh mute          toggle mute
#
# Environment:
#   VOLUME_SINK      sink to control        (default: @DEFAULT_SINK@)
#   VOLUME_MAX       upper limit, percent   (default: 100)
#   VOLUME_TIMEOUT   notification time, ms  (default: 1000)
#
# i3:
#   bindsym XF86AudioRaiseVolume exec --no-startup-id ~/.dotfiles/scripts/volume.sh up 20
#   bindsym XF86AudioLowerVolume exec --no-startup-id ~/.dotfiles/scripts/volume.sh down 20
#   bindsym XF86AudioMute        exec --no-startup-id ~/.dotfiles/scripts/volume.sh mute
#
# Latency notes: only two `pactl` calls happen before the notification is
# launched (17ms each here), and parsing is done with bash builtins, so no
# grep/awk/tr processes are forked. The notification itself is fired in the
# background so it never adds to the time it takes the volume to change.

set -u

readonly SINK="${VOLUME_SINK:-@DEFAULT_SINK@}"
readonly MAX="${VOLUME_MAX:-100}"
readonly TIMEOUT="${VOLUME_TIMEOUT:-1000}"
readonly REPLACE_ID=2593        # fixed id: successive notifications update in place
readonly STEP_DEFAULT=5

die() {
    printf 'volume.sh: %s\n' "$1" >&2
    exit 1
}

usage() {
    printf 'usage: %s {up|down [step]|mute}\n' "${0##*/}" >&2
    exit 2
}

# Populates $vol (percent) and $muted (0/1) for the target sink.
read_state() {
    local out
    out=$(pactl get-sink-volume "$SINK" 2>/dev/null) || die "cannot read volume"
    [[ $out =~ ([0-9]+)% ]] || die "cannot parse volume from: $out"
    vol=${BASH_REMATCH[1]}
    out=$(pactl get-sink-mute "$SINK" 2>/dev/null) || die "cannot read mute state"
    muted=0
    [[ $out == *yes* ]] && muted=1
}

notify() {
    local summary=$1
    # dunstify replaces notifications instantly; notify-send is the fallback.
    if command -v dunstify >/dev/null 2>&1; then
        notify_cmd=(dunstify -a Volume -r "$REPLACE_ID" -t "$TIMEOUT" -h int:transient:1)
    else
        notify_cmd=(notify-send -a Volume -r "$REPLACE_ID" -t "$TIMEOUT" -h int:transient:1)
    fi
    "${notify_cmd[@]}" "$summary" &
}

command -v pactl >/dev/null 2>&1 || die "pactl not found"
command -v notify-send >/dev/null 2>&1 || command -v dunstify >/dev/null 2>&1 \
    || die "neither notify-send nor dunstify found"

action=${1:-}
step=${2:-$STEP_DEFAULT}

case $action in
    up|down|mute) ;;
    *) usage ;;
esac

if [[ $action != mute ]]; then
    [[ $step =~ ^[0-9]+$ ]] || die "step must be a number, got '$step'"
    (( step > 0 )) || die "step must be greater than 0"
fi

read_state

case $action in
    up)
        target=$(( vol + step ))
        (( target > MAX )) && target=$MAX
        pactl set-sink-volume "$SINK" "${target}%" >/dev/null || die "failed to set volume"
        (( muted )) && pactl set-sink-mute "$SINK" 0 >/dev/null
        summary="${target}%"
        ;;
    down)
        target=$(( vol - step ))
        (( target < 0 )) && target=0
        pactl set-sink-volume "$SINK" "${target}%" >/dev/null || die "failed to set volume"
        if (( muted )); then
            summary="${target}% (muted)"
        else
            summary="${target}%"
        fi
        ;;
    mute)
        pactl set-sink-mute "$SINK" toggle >/dev/null || die "failed to toggle mute"
        if (( muted )); then
            summary="Unmuted (${vol}%)"
        else
            summary="Muted (${vol}%)"
        fi
        ;;
esac

notify "$summary"
