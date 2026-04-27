#!/bin/bash
# Waybar custom module + click handler for hypridle.

set -u

SERVICE="hypridle"

emit_status() {
    if pgrep -x "$SERVICE" >/dev/null; then
        printf '{"text": "RUNNING", "class": "active", "tooltip": "Screen locking active\\nLeft: Deactivate\\nRight: Lock Screen"}\n'
    else
        printf '{"text": "NOT RUNNING", "class": "notactive", "tooltip": "Screen locking deactivated\\nLeft: Activate\\nRight: Lock Screen"}\n'
    fi
}

case "${1:-}" in
    status)
        sleep 0.2
        emit_status
        ;;
    toggle)
        if pgrep -x "$SERVICE" >/dev/null; then
            killall "$SERVICE"
        else
            "$SERVICE" &
        fi
        sleep 0.2
        emit_status
        ;;
    *)
        echo "Usage: $0 {status|toggle}" >&2
        exit 1
        ;;
esac
