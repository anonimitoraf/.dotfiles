#!/usr/bin/env bash
# plugins/clock.sh — right-side clock item.
sketchybar --set "$NAME" label="$(date '+%a %d %b  %H:%M')"
