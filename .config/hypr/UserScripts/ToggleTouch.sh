#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/UserConfigs/UserSettings.conf"
ICON_ON="󰹇 "  # Touch ON
ICON_OFF="󱠱 " # Touch OFF

# Check if touch is enabled
if awk '/name = wacom-hid-4924-finger/ { getline; if ($0 ~ /enabled = true/) exit 0; else exit 1; }' "$CONFIG_FILE"; then
    ICON="$ICON_ON"
else
    ICON="$ICON_OFF"
fi

# If clicked, toggle touch mode
if [[ $1 == "toggle" ]]; then
    sed -i '/device {/,/}/ {
      /name = wacom-hid-4924-finger/ {
        N
        s/enabled = true/enabled = false/
        t
        s/enabled = false/enabled = true/
      }
    }' "$CONFIG_FILE"

    if awk '/name = wacom-hid-4924-finger/ { getline; if ($0 ~ /enabled = true/) exit 0; else exit 1; }' "$CONFIG_FILE"; then
        notify-send "Touch Mode Switched ON"
        ICON="$ICON_ON"
    else
        notify-send "Touch Mode Switched OFF"
        ICON="$ICON_OFF"
    fi
fi

# Output JSON for Waybar
printf '{"text":"%s"}\n' "$ICON"
