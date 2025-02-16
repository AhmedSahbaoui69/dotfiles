#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/UserConfigs/UserSettings.conf"

toggle_setting() {
    local section="$1"
    local key="$2"
    local current_value
    current_value=$(awk "/^$section/,/}/" "$CONFIG_FILE" | grep -m1 "$key" | awk -F "=" '{print $2}' | tr -d '[:space:]')
    
    if [[ "$current_value" == "true" || "$current_value" == "yes" ]]; then
        sed -i "/^$section/,/}/s/$key = .*/$key = false/" "$CONFIG_FILE"
    else
        sed -i "/^$section/,/}/s/$key = .*/$key = true/" "$CONFIG_FILE"
    fi
}

toggle_setting "decoration" "enabled"
toggle_setting "animations" "enabled"

if pgrep -x "hyprpaper" > /dev/null; then
    killall swww-daemon
else
    hyprpaper
fi
