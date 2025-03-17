#!/usr/bin/env bash

# Screenshot Directory
dir="$HOME/Pictures/shots"

# Rofi Configuration
rofi_cmd() {
    rofi -theme-str "window {width: 670px;}" \
        -theme-str "listview {columns: 3; lines: 1;}" \
        -theme-str "inputbar { enabled: false; }" \
        -theme-str "element-text { horizontal-align: 0.41; font: \"feather bold 64\";}" \
        -dmenu \
        -mesg "$dir" \
        -markup-rows
}

# Rofi Menu Options
chosen=$(echo -e "󰹑\n\n󰒉" | rofi_cmd)
case $chosen in
    "󰹑") hyprshot -m output -o "$dir" ;;
    "") hyprshot -m window -o "$dir" ;;
    "󰒉") hyprshot -m region -o "$dir" ;;
esac
