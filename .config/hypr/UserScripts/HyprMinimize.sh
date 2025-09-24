#!/bin/bash

mode="$1"

if [ "$mode" = "single" ]; then
    wid=$(hyprctl activewindow -j | jq -r ".address")
    floating=$(hyprctl activewindow -j | jq -r ".floating")

    if [ "$floating" = "true" ]; then
        hyprctl dispatch movetoworkspacesilent special "$wid"
    fi

elif [ "$mode" = "all" ]; then
    current_ws=$(hyprctl activeworkspace | head -n1 | awk '{print $4}' | tr -d '()')
    mapfile -t windows < <(hyprctl clients -j | jq -r '.[] | select(.workspace.name | contains("special")) | .pid')
    for wid in "${windows[@]}"; do
        hyprctl dispatch movetoworkspacesilent "${current_ws},pid:${wid}"
    done
fi

