#!/usr/bin/env bash

# Notifications
source "$HOME/.config/hypr/scripts/notify.sh"

killall hypridle 2>/dev/null || true
sleep 1
hypridle &

notify_user --a "Hypridle" \
        --s "Hypridle has been restarted." \
        --m ""
