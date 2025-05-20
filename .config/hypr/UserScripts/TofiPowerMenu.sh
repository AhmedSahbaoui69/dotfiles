#!/usr/bin/env bash

# Options (as buttons)
shutdown=' 󰐥 '
reboot=' 󰑐 '
lock=' 󰌾 '
suspend=' 󰤄 '
logout=' 󰈆 '

# Present options using tofi with uptime in the prompt text
selected=$(echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | tofi --config ~/.config/tofi/config.conf --prompt-text "" --horizontal true --font-size 100 --padding-left 16% --padding-top 42% --text-cursor false)

# Execute the command corresponding to the chosen option
case "$selected" in
	"$shutdown")
		systemctl poweroff
		;;
	"$reboot")
		systemctl reboot
		;;
	"$suspend")
		mpc -q pause
		amixer set Master mute
		systemctl suspend
		;;
	"$logout")
		hyprctl dispatch exit
		;;
	"$lock")
		waylock
		;;
	*)
		exit 0
		;;
esac
