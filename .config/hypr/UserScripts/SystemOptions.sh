#!/bin/bash

# Define 
declare -A menu_options=(
  ["🗝 Lock"]="lock"
  ["✈ Logout"]="logout"
  ["♻ Reboot"]="reboot"
  ["⏻  Shutdown"]="shutdown"
)

# Main function
main() {
  choice=$(printf "%s\n" "${!menu_options[@]}" | rofi -dmenu -p "")

  if [ -z "$choice" ]; then
    exit 1
  fi

  action="${menu_options[$choice]}"
  
  case "$action" in
    "lock")
      swaylock;;
    "logout")
      hyprctl dispatch exit;;
    "reboot")
      systemctl reboot;;
    "shutdown")
      systemctl poweroff;;
  esac
}

# Run the main function
main
