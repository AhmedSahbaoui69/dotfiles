#!/bin/bash

# Check if wlsunset is already running
if pgrep -x "wlsunset" > /dev/null
then
    # If yes kill it
    pkill -x wlsunset
    notify-send "👁 Night Mode Switched OFF"
else
    # If no start it
    wlsunset -T 4200 &
    notify-send "👁 Night Mode Switched ON"
fi
