#!/bin/bash

is_media_playing() {
  players=$(playerctl -l 2>/dev/null)
  for player in $players; do
    status=$(playerctl -p "$player" status 2>/dev/null)
    if [ "$status" = "Playing" ]; then
      return 0
    fi
  done
  return 1
}

while true; do
  if is_media_playing; then
    pkill -f 'swayidle' 2>/dev/null
  else
    pgrep -f 'swayidle' >/dev/null || swayidle -w \
      timeout 300 'swaylock -f -c 000000' \
      timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
      before-sleep 'swaylock -f -c 000000' &
  fi
  sleep 10
done
