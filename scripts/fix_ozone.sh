#!/bin/bash

# Check if a file path is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path_to_desktop_file>"
    exit 1
fi

desktop_file="$1"
# Check if the file exists
if [ ! -f "$desktop_file" ]; then
    echo "Error: File not found: $desktop_file"
    exit 1
fi

# Check if the flags are already present
if grep -q "Exec=.*--ozone-platform-hint=auto --ozone-platform=wayland" "$desktop_file"; then
    echo "already fixed"
    exit 0
fi

# Add the ozone arguments to all Exec fields
sed -i '/^Exec=/ s/$/ --ozone-platform-hint=auto --ozone-platform=wayland/' "$desktop_file"

echo "Updated $desktop_file"
