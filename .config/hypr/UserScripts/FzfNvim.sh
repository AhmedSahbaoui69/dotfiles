#!/bin/bash
# Recursive File Browser using Tofi and Nvim
browse_dir() {
    local base_dir="$1"
    while true; do
        # Use depth control based on directory
        if [[ "$base_dir" == "$HOME" || "$base_dir" == "$HOME/"* ]]; then
            max_depth=4
        else
            max_depth=1
        fi

        # Find directories first and add "/"
        dirs=$(find -L "$base_dir" -mindepth 1 -maxdepth $max_depth -type d 2>/dev/null | 
               sed "s|^$base_dir/||" | 
               awk '{print $0"/"}')

        # Find files and links
        files=$(find -L "$base_dir" -mindepth 1 -maxdepth $max_depth \( -type f -o -type l \) 2>/dev/null | 
                sed "s|^$base_dir/||")

        # Combine, sort and add parent directory option
        entries=$(printf "..\n%s\n%s" "$dirs" "$files" | sort)

        if [ -z "$entries" ]; then
            echo "No files here." | tofi --prompt-text '' --placeholder-text "Empty Directory"
            return
        fi

        # remove duplicate slashes
        display_path=$(echo "$base_dir/" | tr -s '/')

        # Show selection menu
        selection=$(printf "%s\n" "$entries" | tofi --prompt-text '' --placeholder-text "$display_path" --config ~/.config/tofi/config.conf --ascii-input true --padding-left 40% --padding-top 33% --prompt-padding 0 --num-results 6)
        [ -z "$selection" ] && return

        # Handle ".."
        if [ "$selection" = ".." ]; then
            base_dir=$(dirname "$base_dir")
            continue
        fi

        # Remove trailing slash for path operations
        clean_selection="${selection%/}"
        full_path="$base_dir/$clean_selection"

        if [ -d "$full_path" ]; then
            base_dir="$full_path"
            continue
        elif [ -f "$full_path" ] || [ -L "$full_path" ]; then
            mime_type=$(file --mime-type -b "$full_path")

            # Open specific file types with designated applications
            if [[ "$mime_type" == image/* ]]; then
                eog "$full_path" &
            elif [[ "$mime_type" == application/pdf ]]; then
                evince "$full_path" &
            elif [[ "$mime_type" == video/* ]]; then
                vlc "$full_path" &
            else
                if [ -w "$full_path" ]; then
                    kitty -e nvim "$full_path"
                else
                    kitty -e sudo nvim "$full_path"
                fi
            fi
            return
        fi
    done
}
browse_dir "$HOME"
