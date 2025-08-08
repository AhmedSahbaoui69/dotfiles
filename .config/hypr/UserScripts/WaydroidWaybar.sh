#!/bin/bash
ICON_RUNNING=" "
ICON_STOPPED=" "

# Function to refresh waydroid window sizes
refresh_waydroid_sizes() {
  mapfile -t clients < <(hyprctl clients -j | jq -r '.[] | select(.class | startswith("waydroid.")) | "\(.class) \(.size[0]) \(.size[1])"')
  for c in "${clients[@]}"; do
    read -r class w h <<<"$c"
    app="${class#waydroid.}"
    task_id=$(adb shell am stack list | grep "$app" | sed -n 's/.*taskId=\([0-9]\+\):.*/\1/p')
    [[ -n "$task_id" ]] && adb shell am task resize "$task_id" 0 0 "$w" "$h"
  done
}

# Check waydroid status
STATUS=$(waydroid status 2>/dev/null | grep "Session:" | cut -d':' -f2 | xargs)

if [[ "$STATUS" == "RUNNING" ]]; then
  ICON="$ICON_RUNNING"
else
  ICON="$ICON_STOPPED"
fi

# If clicked, refresh waydroid window sizes
if [[ $1 == "refresh" ]]; then
  if [[ "$STATUS" == "RUNNING" ]]; then
    refresh_waydroid_sizes
  fi
fi

# If toggle, start or stop waydroid session
if [[ $1 == "toggle" ]]; then
  if [[ "$STATUS" == "RUNNING" ]]; then
    systemctl stop waydroid-container.service
    notify-send "   Waydroid Session stopped"
  else
    notify-send "   Waydroid Session started"
    waydroid session start
  fi
fi

# Output JSON for Waybar
printf '{"text":"%s"}\n' "$ICON"
