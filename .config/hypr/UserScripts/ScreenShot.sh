#!/bin/bash

# Get screenshot mode choice
choice=$(echo -e "󰹑  Screen\n  Window\n󰒉  Region" | rofi -dmenu -p "Choose Screenshot Mode:")

# Exit if no mode selected
[ -z "$choice" ] && exit 1

# Take screenshot immediately after mode selection
case "$choice" in
    "󰹑  Screen")
        hyprshot -m output -o $HOME/Pictures/shots/
        ;;
    "  Window")
        hyprshot -m window -o $HOME/Pictures/shots/
        ;;
    "󰒉  Region")
        hyprshot -m region -o $HOME/Pictures/shots/
        ;;
    *)
        exit 1
        ;;
esac
