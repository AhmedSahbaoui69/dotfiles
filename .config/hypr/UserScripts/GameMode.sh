#!/bin/bash

ICON_GAME_ON="󰓅 "
ICON_GAME_OFF="󰌪 "

get_current_governor() {
  cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
}

current_profile=$(get_current_governor)

if [[ "$current_profile" == "performance" ]]; then
  ICON="$ICON_GAME_ON"
else
  ICON="$ICON_GAME_OFF"
fi

if [[ $1 == "toggle" ]]; then
  if [[ "$current_profile" != "performance" ]]; then
    if pkexec cpupower frequency-set -g performance >/dev/null 2>&1; then
      notify-send "Power Profile" "Performance Mode ON"
      ICON="$ICON_GAME_ON"
    else
      notify-send "Failed to activate Game Mode"
      exit 1
    fi
  else
    if pkexec cpupower frequency-set -g powersave >/dev/null 2>&1; then
      notify-send "Power Profile" "Power Save Mode ON"
      ICON="$ICON_GAME_OFF"
    else
      notify-send "Failed to deactivate Game Mode"
      exit 1
    fi
  fi
fi

current_profile=$(get_current_governor)
printf '{"text":"%s","tooltip":"%s"}\n' "$ICON" "$current_profile"