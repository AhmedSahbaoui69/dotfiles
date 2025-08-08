#!/bin/bash
# Scripts for volume controls for audio and mic

# Get Volume
get_volume() {
  volume=$(pamixer --get-volume)
  if [[ "$volume" -eq "0" ]]; then
    echo "Muted"
  else
    echo "$volume%"
  fi
}

# Get emoji icons
get_icon() {
  current=$(get_volume)
  if [[ "$current" == "Muted" ]]; then
    echo "  "
  elif [[ "${current%\%}" -le 60 ]]; then
    echo "  "
  else
    echo "  "
  fi
}

# Notify
notify_user() {
  if [[ "$(get_volume)" == "Muted" ]]; then
    notify-send -e -h string:x-canonical-private-synchronous:volume_notif -u low "$(get_icon) Volume Muted"
  else
    notify-send -e -h int:value:"$(get_volume | sed 's/%//')" -h string:x-canonical-private-synchronous:volume_notif -u low "$(get_icon) Volume $(get_volume)"
  fi
}

# Increase Volume
inc_volume() {
  if [ "$(pamixer --get-mute)" == "true" ]; then
    pamixer -u && notify_user
  fi
  pamixer -i 5 && notify_user
}

# Decrease Volume
dec_volume() {
  if [ "$(pamixer --get-mute)" == "true" ]; then
    pamixer -u && notify_user
  fi
  pamixer -d 5 && notify_user
}

# Toggle Mute
toggle_mute() {
  if [ "$(pamixer --get-mute)" == "false" ]; then
    pamixer -m && notify-send -e -u low "   Volume Switched OFF"
  elif [ "$(pamixer --get-mute)" == "true" ]; then
    pamixer -u && notify-send -e -u low "$(get_icon) Volume Switched ON"
  fi
}

# Toggle Mic
toggle_mic() {
  if [ "$(pamixer --default-source --get-mute)" == "false" ]; then
    pamixer --default-source -m && notify-send -e -u low "    Microphone Switched OFF"
  elif [ "$(pamixer --default-source --get-mute)" == "true" ]; then
    pamixer -u --default-source u && notify-send -e -u low "  Microphone Switched ON"
  fi
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
  get_volume
elif [[ "$1" == "--inc" ]]; then
  inc_volume
elif [[ "$1" == "--dec" ]]; then
  dec_volume
elif [[ "$1" == "--toggle" ]]; then
  toggle_mute
elif [[ "$1" == "--toggle-mic" ]]; then
  toggle_mic
else
  get_volume
fi
