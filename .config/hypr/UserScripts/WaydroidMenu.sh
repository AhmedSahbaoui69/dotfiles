#!/bin/bash
# Get app names and packages
mapfile -t names < <(waydroid app list | grep "^Name:" | sed 's/^Name: //')
mapfile -t packages < <(waydroid app list | grep "packageName:" | sed 's/^packageName: //')

# Show menu with names only
selected=$(printf '%s\n' "${names[@]}" | tofi --prompt-text "Waydroid Apps" --fuzzy-match true --config ~/.config/tofi/config.conf --prompt-text '' --ascii-input true --padding-left 40% --padding-top 33%)

# Exit if no selection
[[ $? -ne 0 || -z "$selected" ]] && exit

# Find package for selected name
for i in "${!names[@]}"; do
  [[ "${names[i]}" == "$selected" ]] && waydroid app launch "${packages[i]}" && ~/.config/hypr/UserScripts/WaydroidWaybar.sh refresh && break
done
