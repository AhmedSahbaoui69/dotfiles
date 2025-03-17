#!/bin/bash

# Config file path
config_file="$HOME/.config/hypr/UserConfigs/Monitors.conf"

# Rofi Configuration
rofi_cmd() {
    rofi -theme-str "window {width: 670px;}" \
        -theme-str "listview {columns: 2; lines: 1;}" \
        -theme-str "inputbar { enabled: false; }" \
        -theme-str "element-text { horizontal-align: 0.5; font: \"feather bold 64\";}" \
        -dmenu \
        -mesg "External Display Mode" \
        -markup-rows
}

choice=$(echo -e "󰌢  󰹑  \n󱜤 " | rofi_cmd)

# Modify the config file based on user choice
case "$choice" in
    "󰌢  󰹑  ")
        sed -i 's/^# monitor = HDMI-A-1, 1920x1200, auto, 1/monitor = HDMI-A-1, 1920x1200, auto, 1/' "$config_file"
        sed -i 's/^monitor = HDMI-A-1, 1680x1050, auto, 1, mirror, eDP-1/# monitor = HDMI-A-1, 1680x1050, auto, 1, mirror, eDP-1/' "$config_file"
        ;;
    "󱜤 ")
        sed -i 's/^monitor = HDMI-A-1, 1920x1200, auto, 1/# monitor = HDMI-A-1, 1920x1200, auto, 1/' "$config_file"
        sed -i 's/^# monitor = HDMI-A-1, 1680x1050, auto, 1, mirror, eDP-1/monitor = HDMI-A-1, 1680x1050, auto, 1, mirror, eDP-1/' "$config_file"
        ;;
    *)
        exit 1
        ;;
esac

