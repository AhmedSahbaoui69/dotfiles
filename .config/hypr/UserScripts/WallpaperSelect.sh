#!/bin/bash
# This script for selecting wallpapers (SUPER W)

SCRIPTSDIR="$HOME/.config/hypr/scripts"

# WALLPAPERS PATH
wallDIR="$HOME/Pictures/wallpapers"

# Transition config
FPS=30
TYPE="wipe"
DURATION=1
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

# Check if swaybg is running
if pidof swaybg > /dev/null; then
  pkill swaybg
fi

# Retrieve image files
PICS=($(ls "${wallDIR}" | grep -E ".jpg$|.jpeg$|.png$|.gif$"))
RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME="${#PICS[@]}. random"

# Rofi command
rofi_command="rofi -show -dmenu"

menu() {
  for i in "${!PICS[@]}"; do
    # Displaying .gif to indicate animated images
    if [[ -z $(echo "${PICS[$i]}" | grep .gif$) ]]; then
      printf "$(echo "${PICS[$i]}" | cut -d. -f1)\x00icon\x1f${wallDIR}/${PICS[$i]}\n"
    else
      printf "${PICS[$i]}\n"
    fi
  done

  printf "$RANDOM_PIC_NAME\n"
}

# Function to list monitors using Hyprland
list_monitors() {
  hyprctl monitors | grep "Monitor" | awk '{print $2}'
}

select_monitor() {
  local monitors=("All" $(list_monitors))
  local monitor_choice=$(printf "%s\n" "${monitors[@]}" | ${rofi_command} -p "Select Monitor")

  echo "$monitor_choice"
}

main() {
  choice=$(menu | ${rofi_command})

  # No choice case
  if [[ -z $choice ]]; then
    exit 0
  fi

  # Random choice case
  if [ "$choice" = "$RANDOM_PIC_NAME" ]; then
    monitor_choice=$(select_monitor)
    if [[ "$monitor_choice" == "All" ]]; then
      swww img "${wallDIR}/${RANDOM_PIC}" $SWWW_PARAMS
    else
      swww img "${wallDIR}/${RANDOM_PIC}" $SWWW_PARAMS --outputs "$monitor_choice"
    fi
    exit 0
  fi

  # Find the index of the selected file
  pic_index=-1
  for i in "${!PICS[@]}"; do
    filename=$(basename "${PICS[$i]}")
    if [[ "$filename" == "$choice"* ]]; then
      pic_index=$i
      break
    fi
  done

  if [[ $pic_index -ne -1 ]]; then
    monitor_choice=$(select_monitor)
    if [[ "$monitor_choice" == "All" ]]; then
      swww img "${wallDIR}/${PICS[$pic_index]}" $SWWW_PARAMS
    else
      swww img "${wallDIR}/${PICS[$pic_index]}" $SWWW_PARAMS --outputs "$monitor_choice"
    fi
  else
    echo "Image not found."
    exit 1
  fi
}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
  exit 0
fi

main

sleep 0.5
${SCRIPTSDIR}/Refresh.sh

