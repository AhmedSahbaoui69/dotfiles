#!/bin/bash

# Kill already running processes
_ps=(waybar tofi mako)
for _prs in "${_ps[@]}"; do
    if pidof "${_prs}" >/dev/null; then
        pkill "${_prs}"
    fi
done

sleep 0.3
# Relaunch waybar
waybar &
# relaunch mako
sleep 0.5
mako &

exit 0
