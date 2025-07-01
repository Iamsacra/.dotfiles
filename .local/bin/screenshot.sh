#!/bin/bash

# Takes the screenshot directory, makes a the directory if it does not exist, 
# creates a tempfile using grim and slurp, and lets us anotate with swappy
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
TEMPFILE=$(mktemp /tmp/screenshot-XXXXXX.png)
grim -g "$(slurp)" "$TEMPFILE"



# Lets us chose between saving the screenshot, or copying to clipboard, if
# its saved, it will be saved in SCREENSHOT_DIR
CHOISE=$(echo -e "Save\nCopy to clipboard" | wofi --dmenu --prompt="What to do?")

case "$CHOISE" in
    Save)
        DEST="$SCREENSHOT_DIR/screenshot_$(date +%d-%m-%Y_%H-%M).png"
        mv "$TEMPFILE" "$DEST"
        notify-send --expire-time=5000 "Screenshot saved" "$DEST"
        ;;
    "Copy to clipboard") 
        wl-copy < "$TEMPFILE"
        rm "$TEMPFILE"
        notify-send --expire-time=5000 "Screenshot copied" "Image copied to clipboard"
        ;;
    *)
        rm "TEMPFILE"
        notify-send --expire-time=5000 "Screenshot canceled"
        ;;
esac
