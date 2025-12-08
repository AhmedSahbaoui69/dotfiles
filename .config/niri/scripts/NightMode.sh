#!/bin/bash

ICON_ON="󰈈 "  # Night mode ON
ICON_OFF="󰈉 " # Night mode OFF

# Check if wlsunset is running
if pgrep -x "wlsunset" >/dev/null; then
  ICON="$ICON_ON"
else
  ICON="$ICON_OFF"
fi

# If clicked, toggle wlsunset
if [[ $1 == "toggle" ]]; then
  if [[ $ICON == "$ICON_ON" ]]; then
    pkill -x wlsunset
    notify-send "   Night Mode Switched OFF"
    ICON="$ICON_OFF"
  else
    wlsunset -T 4200 &
    notify-send "󰛐   Night Mode Switched ON"
    ICON="$ICON_ON"
  fi
fi

# Output JSON for Waybar
printf '{"text":"%s"}\n' "$ICON"
