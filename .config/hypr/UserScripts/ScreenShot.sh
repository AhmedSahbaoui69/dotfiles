#!/bin/bash

# Options
yes='Y'
no='N'

# Custom confirmation dialog for URL handler only
confirm_cmd() {
    rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 2; lines: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -dmenu \
        -p 'Confirmation' \
        -mesg 'Send with KDE Connect?' \
        -theme $HOME/dotfiles/.local/share/rofi/themes/power-style.rasi
}

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

# Get latest screenshot filename
latest_shot=$(ls -t $HOME/Pictures/shots | head -1)

# Show themed confirmation only for URL handler
handler_confirm=$(echo -e "$yes\n$no" | confirm_cmd)

# Open handler only if confirmed
if [ "$handler_confirm" = "$yes" ]; then
    kdeconnect-handler --open $HOME/Pictures/shots/$latest_shot
fi