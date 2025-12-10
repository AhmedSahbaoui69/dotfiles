# Get Mic Volume
get_mic_volume() {
  pamixer --default-source --get-volume
}

# Get Mic Icon
get_mic_icon() {
  mic_vol=$(get_mic_volume)
  if [ "$(pamixer --default-source --get-mute)" == "true" ]; then
    echo ""
  elif [ "$mic_vol" -le 25 ]; then
    echo ""
  elif [ "$mic_vol" -le 60 ]; then
    echo ""
  else
    echo ""
  fi
}

# Notify Mic
notify_mic() {
  if [ "$(pamixer --default-source --get-mute)" == "true" ]; then
    notify-send -e -h string:x-canonical-private-synchronous:mic_notif -u low " Microphone Muted"
  else
    notify-send -e -h int:value:"$(get_mic_volume)" -h string:x-canonical-private-synchronous:mic_notif -u low "$(get_mic_icon)  Microphone $(get_mic_volume)%"
  fi
}
#!/bin/bash

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
  elif [[ "${current%\%}" -le 25 ]]; then
    echo "  "
  elif [[ "${current%\%}" -le 60 ]]; then
    echo " "
  else
    echo " "
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

# Increase Mic Volume
inc_mic_volume() {
  if [ "$(pamixer --default-source --get-mute)" == "true" ]; then
    pamixer --default-source -u
  fi
  pamixer --default-source -i 2
  notify_mic
}

# Decrease Mic Volume
dec_mic_volume() {
  if [ "$(pamixer --default-source --get-mute)" == "true" ]; then
    pamixer --default-source -u
  fi
  pamixer --default-source -d 2
  notify_mic
}


# Increase Volume
inc_volume() {
  if [ "$(pamixer --get-mute)" == "true" ]; then
    pamixer -u && notify_user
  fi
  pamixer -i 2 && notify_user
}

# Decrease Volume
dec_volume() {
  if [ "$(pamixer --get-mute)" == "true" ]; then
    pamixer -u && notify_user
  fi
  pamixer -d 2 && notify_user
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
    pamixer --default-source -m && notify-send -e -u low "  Microphone Switched OFF"
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
elif [[ "$1" == "--mic-inc" ]]; then
  inc_mic_volume
elif [[ "$1" == "--mic-dec" ]]; then
  dec_mic_volume
else
  get_volume
fi
