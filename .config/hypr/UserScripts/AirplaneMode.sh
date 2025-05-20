
# Airplane Mode Toggle.. 

# Check if any wireless device is blocked
wifi_blocked=$(rfkill list wifi | grep -o "Soft blocked: yes")

if [ -n "$wifi_blocked" ]; then
    notify-send 'Airplane mode: OFF'
else
    notify-send 'Airplane mode: ON'
fi
