#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/UserConfigs/UserSettings.conf"

# Icons
ICON_GAME_ON="󰓅 "  # Game Mode ON
ICON_GAME_OFF="󰌪 " # Game Mode OFF

# Get current CPU governor
get_current_governor() {
  cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
}

current_profile=$(get_current_governor)

if [[ "$current_profile" == "performance" ]]; then
  ICON="$ICON_GAME_ON"
else
  ICON="$ICON_GAME_OFF"
fi

toggle_setting() {
  local section="$1"
  local key="$2"
  local current_value

  current_value=$(awk "/^[[:space:]]*$section/,/}/" "$CONFIG_FILE" | grep -m1 "$key" | awk -F "=" '{print $2}' | tr -d '[:space:]')

  if [[ "$current_value" == "true" || "$current_value" == "yes" ]]; then
    sed -i "/^[[:space:]]*$section/,/}/s/$key = .*/$key = false/" "$CONFIG_FILE"
  else
    sed -i "/^[[:space:]]*$section/,/}/s/$key = .*/$key = true/" "$CONFIG_FILE"
  fi
}

# Handle toggle
if [[ $1 == "toggle" ]]; then
  if [[ "$current_profile" != "performance" ]]; then
    if pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY cpupower frequency-set -g performance >/dev/null 2>&1; then
      notify-send "Power Profile" "Performance Mode ON"
      toggle_setting "blur" "enabled"
      toggle_setting "animations" "enabled"
      ICON="$ICON_GAME_ON"
    else
      notify-send "Failed to activate Game Mode"
      exit 1
    fi
  else
    if pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY cpupower frequency-set -g powersave >/dev/null 2>&1; then
      notify-send "Power Profile" "Power Save Mode ON"
      toggle_setting "blur" "enabled"
      toggle_setting "animations" "enabled"
      ICON="$ICON_GAME_OFF"
    else
      notify-send "Failed to deactivate Game Mode"
      exit 1
    fi
  fi
fi

# Final governor state for tooltip
current_profile=$(get_current_governor)

# Output JSON for Waybar
printf '{"text":"%s","tooltip":"%s"}\n' "$ICON" "$current_profile"
