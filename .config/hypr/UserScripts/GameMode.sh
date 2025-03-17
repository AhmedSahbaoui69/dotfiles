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

toggle_opacity() {
	# Get the current opacity values
	active_opacity=$(awk "/^[[:space:]]*active_opacity/ {print \$3}" "$CONFIG_FILE")
	inactive_opacity=$(awk "/^[[:space:]]*inactive_opacity/ {print \$3}" "$CONFIG_FILE")

	if [[ "$active_opacity" == "1.0" && "$inactive_opacity" == "1.0" ]]; then
		# Set them back to original values
		sed -i "s/^[[:space:]]*active_opacity = .*/active_opacity = 0.90/" "$CONFIG_FILE"
		sed -i "s/^[[:space:]]*inactive_opacity = .*/inactive_opacity = 0.92/" "$CONFIG_FILE"
	else
		# Set both to 1.0
		sed -i "s/^[[:space:]]*active_opacity = .*/active_opacity = 1.0/" "$CONFIG_FILE"
		sed -i "s/^[[:space:]]*inactive_opacity = .*/inactive_opacity = 1.0/" "$CONFIG_FILE"
	fi
}

# If clicked toggle game mode
if [[ $1 == "toggle" ]]; then
  toggle_setting "blur" "enabled"
  toggle_setting "animations" "enabled"
  toggle_opacity

  current_profile=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
  if [[ "$current_profile" != "performance" ]]; then
      pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY cpupower frequency-set -g performance > /dev/null 
      notify-send "Game Mode Activated"
      ICON="$ICON_GAME_ON"
  else
      pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY cpupower frequency-set -g powersave > /dev/null 
      notify-send "Game Mode Deactivated"
      ICON="$ICON_GAME_OFF"
  fi
fi

# Output JSON for Waybar
printf '{"text":"%s"}\n' "$ICON"

