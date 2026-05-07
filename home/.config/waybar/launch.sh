#!/usr/bin/env bash

exec 200>/tmp/waybar-launch.lock
flock -n 200 || exit 0

killall waybar 2>/dev/null
while pgrep -x waybar >/dev/null; do sleep 0.1; done

HYPRLAND_INSTANCE_SIGNATURE=$(hyprctl instances -j | jq -r '.[0].instance') \
    setsid waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css >/dev/null 2>&1 200>&- &
disown
