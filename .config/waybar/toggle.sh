#!/usr/bin/env bash

if pgrep waybar > /dev/null; then
    killall waybar
else
    ~/.config/waybar/launch.sh &
fi
