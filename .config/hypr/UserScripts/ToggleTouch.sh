#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/UserConfigs/UserSettings.conf"

sed -i '/device {/,/}/ {
  /name = wacom-hid-4924-finger/ {
    N
    s/enabled = true/enabled = false/
    t
    s/enabled = false/enabled = true/
  }
}' "$CONFIG_FILE"

if awk '/name = wacom-hid-4924-finger/ { getline; if ($0 ~ /enabled = true/) exit 0; else exit 1; }' "$CONFIG_FILE"; then
      notify-send "Touch Mode Switched ON"
else
      notify-send "Touch Mode Switched OFF"
fi

