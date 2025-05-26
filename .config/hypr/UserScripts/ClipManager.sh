#!/bin/bash

# Path to temp config
TMP_CONFIG="/tmp/tofi_config_copy"

# Create temp config if it doesn't exist
if [ ! -f "$TMP_CONFIG" ]; then
    cp ~/.config/tofi/config.conf "$TMP_CONFIG"
    echo "font = JetBrains Mono" >> "$TMP_CONFIG"
fi

# Clipboard Manager using tofi, cliphist, and wl-copy
while true; do
    result=$(cliphist list | tofi --prompt-text "" --fuzzy-match true --config "$TMP_CONFIG" --padding-left 25% --padding-right 25% --padding-top 14% --num-results 15 --font-size 15)

    # Exit if tofi was cancelled
    if [ $? -ne 0 ]; then
        exit
    fi

    # Copy the decoded clip history entry to the clipboard
    cliphist decode <<<"$result" | wl-copy
    exit
done

