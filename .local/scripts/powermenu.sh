#!/bin/bash

options="Lock\nSign Out\nReboot\nSleep\nShutdown"

choice=$(echo -e "$options" | wofi \
    --dmenu \
    --hide-search=true \
    --prompt "" \
    --no-show-icons \
    --no-sort )

case "$choice" in
    "Lock")
        swaylock
        ;;
    "Sign Out")
        swaymsg exit
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Sleep")
        systemctl suspend
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
    *)
        ;;
esac

