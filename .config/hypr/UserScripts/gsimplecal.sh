#!/bin/bash

gsimplecal &
sleep 0.1

while pgrep -x gsimplecal >/dev/null; do
    sleep 0.2
    if ! hyprctl activewindow | grep -q "gsimplecal"; then
        pkill gsimplecal
        exit
    fi
done

