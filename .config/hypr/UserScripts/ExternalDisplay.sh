#!/bin/bash

# Config file path
config_file="$HOME/.config/hypr/UserConfigs/Monitors.conf"

# Define options
option1=" 󰌢  󰹑   "
option2=" 󱜤 "

# Present options using tofi
selected=$(echo -e "$option1\n$option2" | tofi --config "$HOME/.config/tofi/config.conf" \
    --prompt-text "" \
    --horizontal true \
    --font-size 100 \
    --padding-left 30% \
    --padding-top 42% \
    --text-cursor false)

# Modify the config file based on user choice
case "$selected" in
    "$option1")
        sed -i 's/^# monitor = HDMI-A-1, 1920x1200, auto, 1/monitor = HDMI-A-1, 1920x1200, auto, 1/' "$config_file"
        sed -i 's/^monitor = HDMI-A-1, 1680x1050, auto, 1, mirror, eDP-1/# monitor = HDMI-A-1, 1680x1050, auto, 1, mirror, eDP-1/' "$config_file"
        ;;
    "$option2")
        sed -i 's/^monitor = HDMI-A-1, 1920x1200, auto, 1/# monitor = HDMI-A-1, 1920x1200, auto, 1/' "$config_file"
        sed -i 's/^# monitor = HDMI-A-1, 1680x1050, auto, 1, mirror, eDP-1/monitor = HDMI-A-1, 1680x1050, auto, 1, mirror, eDP-1/' "$config_file"
        ;;
    *)
        exit 1
        ;;
esac
