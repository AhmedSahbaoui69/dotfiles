#!/bin/bash
# Screenshots script

iDIR="$HOME/.config/swaync/icons"
notify_cmd_shot="notify-send -h string:x-canonical-private-synchronous:shot-notify -u low -i ${iDIR}/picture.png"

time=$(date "+%d-%b_%H-%M-%S")
dir="$(xdg-user-dir PICTURES)/Screenshots"
file="Screenshot_${time}_${RANDOM}.png"

# Function to notify and view screenshot
notify_view() {
    if [[ "$1" == "active" ]]; then
        if [[ -e "${active_window_path}" ]]; then
            ${notify_cmd_shot} "Screenshot of '${active_window_class}' Saved."
        else
            ${notify_cmd_shot} "Screenshot of '${active_window_class}' NOT Saved."
        fi
    else
        local check_file="${dir}/${file}"
        if [[ -e "${check_file}" ]]; then
            ${notify_cmd_shot} "Screenshot Saved."
        else
            ${notify_cmd_shot} "Screenshot NOT Saved."
        fi
    fi
}

# Countdown function
countdown() {
    for sec in $(seq $1 -1 1); do
        notify-send -h string:x-canonical-private-synchronous:shot-notify -t 500 -i "$iDIR/timer.png" "Taking shot in: $sec"
        sleep 1
    done
}

# Take screenshot immediately
shotnow() {
    cd "${dir}" && grim - | tee "${file}" | wl-copy
    sleep 2
    notify_view
}

# Take screenshot after 5 seconds
shot5() {
    countdown '5'
    sleep 1
    cd "${dir}" && grim - | tee "${file}" | wl-copy
    sleep 1
    notify_view
}

# Take screenshot of active window
shotwin() {
    w_pos=$(hyprctl -j activewindow | jq -r '.at | "\(.[0]),\(.[1])"')
    w_size=$(hyprctl -j activewindow | jq -r '.size | "\(.[0])x\(.[1])"')
    cd "${dir}" && grim -g "${w_pos} ${w_size}" - | tee "${file}" | wl-copy
    notify_view
}

# Take screenshot of a selected area
shotarea() {
    cd "${dir}" && grim -g "$(slurp)" - | tee "${file}" | wl-copy
    notify_view
}

# Take screenshot of active window with custom filename
shotactive() {
    active_window_class=$(hyprctl -j activewindow | jq -r '(.class)')
    active_window_file="Screenshot_${time}_${active_window_class}.png"
    active_window_path="${dir}/${active_window_file}"

    hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - "${active_window_path}"
    sleep 1
    notify_view "active"
}

# Create directory if it does not exist
if [[ ! -d "${dir}" ]]; then
    mkdir -p "${dir}"
fi

# Handle script options
case "$1" in
    --now)
        shotnow
        ;;
    --in5)
        shot5
        ;;
    --win)
        shotwin
        ;;
    --area)
        shotarea
        ;;
    --active)
        shotactive
        ;;
    *)
        echo "Available Options: --now --in5 --win --area --active"
        ;;
esac

exit 0

