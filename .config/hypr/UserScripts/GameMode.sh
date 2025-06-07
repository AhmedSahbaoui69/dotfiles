#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/UserConfigs/UserSettings.conf"

# Icons
ICON_GAME_ON="󰓅 "  # Game Mode ON
ICON_GAME_OFF="󰌪 " # Game Mode OFF

# Check if Game Mode (Performance) is enabled
current_profile=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)

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

# If clicked toggle game mode
if [[ $1 == "toggle" ]]; then
  toggle_setting "blur" "enabled"
  toggle_setting "animations" "enabled"

  current_profile=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
  if [[ "$current_profile" != "performance" ]]; then
    pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY cpupower frequency-set -g performance >/dev/null
    notify-send "Game Mode Activated"
    ICON="$ICON_GAME_ON"
  else
    pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY cpupower frequency-set -g powersave >/dev/null
    notify-send "Game Mode Deactivated"
    ICON="$ICON_GAME_OFF"
  fi
fi

# Output JSON for Waybar
printf '{"text":"%s"}\n' "$ICON"
