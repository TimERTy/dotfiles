#!/usr/bin/env bash
# Power menu actions: gracefully terminate clients then perform system action.

set -u

TERM_TIMEOUT=5

terminate_clients() {
    local pids pid start now elapsed
    pids=$(hyprctl clients -j | jq -r '.[] | .pid')

    for pid in $pids; do
        echo ":: Sending SIGTERM to PID $pid"
        kill -15 "$pid" 2>/dev/null
    done

    for pid in $pids; do
        start=$(date +%s)
        while kill -0 "$pid" 2>/dev/null; do
            now=$(date +%s)
            elapsed=$(( now - start ))
            if (( elapsed >= TERM_TIMEOUT )); then
                echo ":: Timeout reached for PID $pid."
                break
            fi
            echo ":: Waiting for PID $pid to terminate..."
            sleep 1
        done
        if ! kill -0 "$pid" 2>/dev/null; then
            echo ":: PID $pid has terminated."
        fi
    done
}

case "${1:-}" in
    exit)
        echo ":: Exit"
        terminate_clients
        sleep 0.5
        hyprctl dispatch exit
        sleep 2
        ;;
    lock)
        echo ":: Lock"
        sleep 0.5
        hyprlock
        ;;
    reboot)
        echo ":: Reboot"
        terminate_clients
        sleep 0.5
        systemctl reboot
        ;;
    shutdown)
        echo ":: Shutdown"
        terminate_clients
        sleep 0.5
        systemctl poweroff
        ;;
    suspend)
        echo ":: Suspend"
        sleep 0.5
        systemctl suspend
        ;;
    hibernate)
        echo ":: Hibernate"
        sleep 1
        systemctl hibernate
        ;;
    *)
        echo "Usage: $0 {exit|lock|reboot|shutdown|suspend|hibernate}" >&2
        exit 1
        ;;
esac
