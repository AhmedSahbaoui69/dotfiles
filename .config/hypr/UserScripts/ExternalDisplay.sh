#!/bin/bash

# Config file path
config_file="$HOME/.config/hypr/UserConfigs/Monitors.conf"

# Get user choice
choice=$(echo -e "󰹑  Extend Display\n  Mirror Display" | rofi -dmenu -p "Choose Display Mode:")

# Modify the config file based on user choice
case "$choice" in
    "󰹑  Extend Display")
        sed -i 's/^# monitor = HDMI-A-1, 1920x1200, auto, 1/monitor = HDMI-A-1, 1920x1200, auto, 1/' "$config_file"
        sed -i 's/^monitor = HDMI-A-1, 1680x1050, auto, 1, mirror, eDP-1/# monitor = HDMI-A-1, 1680x1050, auto, 1, mirror, eDP-1/' "$config_file"
        ;;
    "  Mirror Display")
        sed -i 's/^monitor = HDMI-A-1, 1920x1200, auto, 1/# monitor = HDMI-A-1, 1920x1200, auto, 1/' "$config_file"
        sed -i 's/^# monitor = HDMI-A-1, 1680x1050, auto, 1, mirror, eDP-1/monitor = HDMI-A-1, 1680x1050, auto, 1, mirror, eDP-1/' "$config_file"
        ;;
    *)
        exit 1
        ;;
esac

