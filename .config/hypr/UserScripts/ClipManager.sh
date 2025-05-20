#!/bin/bash

# Clipboard Manager using tofi, cliphist, and wl-copy.
# Note: Custom keybindings for delete actions have been removed
#       because tofi does not natively support them.

while true; do
    result=$(cliphist list | tofi --prompt-text "" --fuzzy-match true --config ~/.config/tofi/config.conf --padding-left 25% --padding-right 25% --padding-top 14% --num-results 15 --font-size 15)

    # Exit if tofi was cancelled (nonzero exit status)
    if [ $? -ne 0 ]; then
        exit
    fi

    # Copy the decoded clip history entry to the clipboard.
    cliphist decode <<<"$result" | wl-copy
    exit
done
