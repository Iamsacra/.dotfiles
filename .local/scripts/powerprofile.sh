#!/bin/bash

current=$(powerprofilesctl get)

options="Performance\nBalanced\nPower Saver"

choice=$(echo -e "$options" | wofi --dmenu --prompt "Power Mode (Current: $current)" --no-search)

case "$choice" in
    "Performance")
        powerprofilesctl set performance
        ;;
    "Balanced")
        powerprofilesctl set balanced
        ;;
    "Power Saver")
        powerprofilesctl set power-saver
        ;;
    *)
        # Do nothing
        ;;
esac

