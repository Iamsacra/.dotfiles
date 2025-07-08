#!/bin/bash

# Load user directories if available
[ -f "$HOME/.config/user-dirs.dirs" ] && source "$HOME/.config/user-dirs.dirs"

PICTURES_DIR="${XDG_PICTURES_DIR}"
SCREENSHOT_DIR="$PICTURES_DIR/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Run slurp and check if user canceled
SELECTION=$(slurp)
if [ -z "$SELECTION" ]; then
  notify-send --expire-time=3000 "Screenshot Cancelled"
  exit 1
fi

TEMPFILE=$(mktemp /tmp/screenshot-XXXXXX.png)
grim -g "$SELECTION" "$TEMPFILE"

# Check if grim succeeded and file is not empty
if [ ! -s "$TEMPFILE" ]; then
  rm -f "$TEMPFILE"
  notify-send --expire-time=3000 "Screenshot Failed"
  exit 1
fi

DEST="$SCREENSHOT_DIR/screenshot_$(date +%d-%m-%Y_%H-%M-%S).png"
cp "$TEMPFILE" "$DEST"
wl-copy < "$TEMPFILE"
rm "$TEMPFILE"

notify-send --expire-time=5000 "Screenshot Saved & Copied" "Saved to: $DEST"
