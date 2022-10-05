#!/bin/bash

external_monitor=$(xrandr --query | grep 'HDMI-1')
if [[ ! $external_monitor = *disconnected* ]]; then
    # echo "Monitor connected"
		xrandr --output eDP-1 --mode 1600x900 --pos 2560x90 --rotate normal --output HDMI-1 --primary --mode 2560x1080 --pos 0x0 --rotate normal --output DP-1 --off
else
    # echo "Monitor disconnected"
    xrandr --output eDP-1 --primary --mode 1600x900 --pos 0x0 --rotate normal --output HDMI-1 --off --output DP-1 --off
fi


