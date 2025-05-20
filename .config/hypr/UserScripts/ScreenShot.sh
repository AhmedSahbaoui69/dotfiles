#!/usr/bin/env bash

# Screenshot Directory
dir="$HOME/Pictures/shots"

# tofi Menu Options
chosen=$(echo -e " \n  \n  \n " | tofi --config ~/.config/tofi/config.conf --prompt-text "" --horizontal true --font-size 100 --padding-left 25% --padding-right 25% --padding-top 44% --text-cursor false)
case "$chosen" in
" ")
    hyprshot -m output -o "$dir"
    ;;
"  ")
    hyprshot -m window -o "$dir"
    ;;
"  ")
    hyprshot -m region -o "$dir"
    ;;
" ")
    flatpak run com.dec05eba.gpu_screen_recorder
    ;;
esac
