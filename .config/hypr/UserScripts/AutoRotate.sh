#!/bin/bash

ICON_OFF="󰌢 "
ICON_ON="󰢅 "

# Check if iio-hyprland is running
if pgrep -x "iio-hyprland" >/dev/null; then
  ICON="$ICON_ON"
else
  ICON="$ICON_OFF"
fi

# If clicked, toggle iio-hyprland
if [[ $1 == "toggle" ]]; then
  if [[ $ICON == "$ICON_ON" ]]; then
    pkill -x iio-hyprland
    notify-send "󰌢   Auto Rotate OFF"
    ICON="$ICON_OFF"
  else
    iio-hyprland &
    notify-send "󰢅   Auto Rotate ON"
    ICON="$ICON_ON"
  fi
fi

# Output JSON for Waybar
printf '{"text":"%s"}\n' "$ICON"
