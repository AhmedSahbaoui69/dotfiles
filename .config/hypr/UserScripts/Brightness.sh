#!/bin/bash

# Get brightness
get_backlight() {
  echo $(brightnessctl -m | cut -d, -f4)
}

# Get emoji based on brightness level
get_emoji() {
  current=$(get_backlight | sed 's/%//')
  if [ "$current" -le "30" ]; then
    emoji="󰃞  "
  elif [ "$current" -le "60" ]; then
    emoji="󰃝  "
  elif [ "$current" -le "65" ]; then
    emoji="󰃟  "
  else
    emoji="󰃠  "
  fi
}

# Notify
notify_user() {
  notify-send -e -h string:x-canonical-private-synchronous:brightness_notif -h int:value:$current -u low "$emoji Brightness $current%"
}

# Change brightness
change_backlight() {
  brightnessctl set "$1" && get_emoji && notify_user
}

# Execute accordingly
case "$1" in
"--get")
  get_backlight
  ;;
"--inc")
  change_backlight "+5%"
  ;;
"--dec")
  change_backlight "5%-"
  ;;
*)
  get_backlight
  ;;
esac
