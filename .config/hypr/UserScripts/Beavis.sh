#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INDEX_FILE="$SCRIPT_DIR/current_line_dialogue.txt"

dialogue=(
  "We're gonna be talkin' about PENIS!"
  "We'll be talkin' about VAGINA!"
  "Do you think that's funny, Butt-head?!"
  "Do you find it amusing that we'll be talkin' about TESTICLES?!"
  "Yes, we're also gonna be talkin' about VENEREAL!"
  "SEXUAL!"
  "SCROTUM!"
  "And... and we will definitely be spending a lot of time talking about MASTURBATION!!"
)

random_words=(
  "skibidi toilet" "gyatt" "the rizzler" "ohio boss" "duke dennis"
  "livvy dunne" "baby gronk" "andrew tate"
  "caseoh" "ishowspeed" "kai cenat" "freaky ahh"
  "fanum tax" "edging" "bussing" "axel in harlem" "aiden ross"
  "grimace shake" "glizzy" "thug shaker" "mewing"
  "looksmaxxing" "mrbeast" "ice spice" "gooning"
)

replace_caps() {
  local line="$1"
  echo "$line" | sed -E "s/\b[A-Z]+\b/$(echo ${random_words[$RANDOM % ${#random_words[@]}]} | tr '[:lower:]' '[:upper:]')/g"
}

if [ ! -f "$INDEX_FILE" ]; then
  echo 0 > "$INDEX_FILE"
fi

current_line=$(<"$INDEX_FILE")

current_dialogue="${dialogue[$current_line]}"
modified_dialogue=$(replace_caps "$current_dialogue")

echo "$modified_dialogue"

next_line=$(( (current_line + 1) % ${#dialogue[@]} ))
echo "$next_line" > "$INDEX_FILE"
