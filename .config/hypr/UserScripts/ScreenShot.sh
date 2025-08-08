#!/usr/bin/env bash

# Screenshot Directory
dir="$HOME/Media/shots"

# tofi Menu Options
chosen=$(echo -e " \n  \n  \n " | tofi --config ~/.config/tofi/config.conf --prompt-text "" --horizontal true --font-size 100 --padding-left 26% --padding-top 44% --text-cursor false)
case "$chosen" in
" ")
  hyprshot -m output -o "$dir"
  ;;
"  ")
  hyprshot -m window -o "$dir"
  ;;
"  ")
  hyprshot -m region -o "$dir" && tesseract "$dir"
  ;;
" ")
  gpu-screen-recorder-gtk
  ;;
esac
