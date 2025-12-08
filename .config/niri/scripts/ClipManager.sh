#!/bin/bash

# Path to temp config
TMP_CONFIG="/tmp/tofi_config_copy"

# Create temp config if it doesn't exist
if [ ! -f "$TMP_CONFIG" ]; then
  cp ~/.config/tofi/config.conf "$TMP_CONFIG"
  echo "font = JetBrains Mono" >>"$TMP_CONFIG"
  echo "require-match = false" >>"$TMP_CONFIG"
else
  # Ensure require-match is false in the temp config
  grep -q '^require-match' "$TMP_CONFIG" || echo "require-match = false" >>"$TMP_CONFIG"
fi

# Clipboard Manager using tofi, cliphist, and wl-copy
while true; do
  # Get list from cliphist and append "restart" option
  entries=$(
    cliphist list
    echo "restart"
  )

  result=$(echo "$entries" | tofi \
    --prompt-text "" \
    --fuzzy-match true \
    --require-match false \
    --config "$TMP_CONFIG" \
    --padding-left 25% \
    --padding-right 25% \
    --padding-top 14% \
    --num-results 15 \
    --font-size 15)

  # Exit if tofi was cancelled
  if [ $? -ne 0 ]; then
    exit
  fi

  # Handle "restart"
  if [[ "$result" == "restart" ]]; then
    killall wl-paste 2>/dev/null
    wl-paste --type text --watch cliphist store
    wl-paste --type image --watch cliphist store
    continue
  fi

  # Copy the decoded clip history entry to the clipboard
  cliphist decode <<<"$result" | wl-copy
  exit
done
