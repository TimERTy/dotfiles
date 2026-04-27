#!/bin/bash

VPN="nz.protonvpn.udp"

connected_icon=$'\uf3ed'
disconnected_icon=$'\uf132'

print_status() {
    if nmcli connection show --active | grep -q "$VPN"; then
        echo "{\"text\": \"$connected_icon\", \"class\": \"connected\", \"tooltip\": \"VPN: Connected\nLeft: Disconnect\"}"
    else
        echo "{\"text\": \"$disconnected_icon\", \"class\": \"disconnected\", \"tooltip\": \"VPN: Disconnected\nLeft: Connect\"}"
    fi
}

case "$1" in
    status)
        sleep 0.2
        print_status
        ;;
    toggle)
        if nmcli connection show --active | grep -q "$VPN"; then
            nmcli connection down "$VPN"
        else
            nmcli connection up "$VPN"
        fi
        sleep 0.5
        print_status
        ;;
    *)
        echo "Usage: $0 {status|toggle}"
        exit 1
        ;;
esac
