#!/usr/bin/env bash

# Directory fallback
dir="$HOME/Media/shots"

# Get last clipboard image (using wl-clipboard for Wayland; xclip/xsel for X11)
clip_image="/tmp/clipboard_image.png"
if wl-paste --type image >"$clip_image" 2>/dev/null; then
  img="$clip_image"
else
  # fallback to last image in directory
  img=$(ls -t "$dir"/*.{png,jpg,jpeg} 2>/dev/null | head -n1)
fi

# Options as distinct variables
option_ocr="OCR"
option_qr="QR"

# Tofi menu
chosen=$(echo -e "$option_ocr\n$option_qr" | tofi --config ~/.config/tofi/config.conf --prompt-text "" --horizontal true --font-size 100 --padding-left 26% --padding-top 44% --text-cursor false)

case "$chosen" in
"$option_ocr")
  if [ -n "$img" ]; then
    tesseract "$img" - # outputs text to stdout
  else
    notify-send "No image found for OCR"
  fi
  ;;
"$option_qr")
  if [ -n "$img" ]; then
    zbarimg "$img" # outputs QR content to stdout
  else
    notify-send "No image found for QR scanning"
  fi
  ;;
esac
