#!/bin/bash

# Directory to start from
DIR="${1:-$HOME}"

while true; do
  # List files and directories
  FILE=$( (echo ".."; find "$DIR" -maxdepth 1 -mindepth 1 | sed "s|^$DIR/|./|" | sort | while read -r line; do
    if [ -d "$DIR/${line#./}" ]; then
      echo "$line/"
    else
      echo "$line"
    fi
  done) | rofi -dmenu -i -p "$DIR")

  # If no file selected, exit
  [ -z "$FILE" ] && exit

  # Handle going to parent directory
  if [ "$FILE" = ".." ]; then
    DIR=$(dirname "$DIR")
    continue
  fi

  # If a directory is selected, change into that directory
  if [ -d "$DIR/${FILE#./}" ]; then
    DIR="${DIR}/${FILE#./}"
    DIR="${DIR%/}" # Remove trailing slash if exists
    continue
  fi

  # If a file is selected, open it in nvim
  if [ -f "$DIR/${FILE#./}" ]; then
    kitty -e sudo nvim "$DIR/${FILE#./}"
    exit
  fi
done
