#!/bin/dash
# Recursive File Browser using Tofi and Nvim (dash-compatible)

open_file() {
  mime=$(file --mime-type -b "$1")
  case "$mime" in
  image/*) eog "$1" & ;;
  application/pdf) evince "$1" & ;;
  video/*) vlc "$1" & ;;
  *) [ -w "$1" ] && kitty -e nvim "$1" || kitty -e sudo nvim "$1" ;;
  esac
}

get_padding() {
  [ "$1" -le 50 ] && echo 40 && return
  [ "$1" -le 100 ] && echo 25 && return
  echo 10
}

average_length() {
  awk '{ total += length } END { print (NR > 0 ? int(total / NR) : 0) }'
}

browse_dir() {
  base_dir="$1"
  while :; do
    entries=$(
      printf "..\n"
      find -L "$base_dir" -mindepth 1 -maxdepth 1 -type d \
        ! -path "$base_dir/.cache" ! -path "$base_dir/.local/state" ! -name ".venv" 2>/dev/null |
        sed "s|^$base_dir/||; s|$|/|"
      find -L "$base_dir" -mindepth 1 -maxdepth 1 \( -type f -o -type l \) \
        ! -path "$base_dir/.cache/*" ! -path "$base_dir/.local/nvim/*" 2>/dev/null |
        sed "s|^$base_dir/||" | sort
    )

    [ -z "$entries" ] && {
      echo "No files here." | tofi --prompt-text '' --placeholder-text "Empty Directory" \
        --font /usr/share/fonts/TTF/JetBrainsMono-Regular.ttf --font-size 16
      return
    }

    avg_len=$(printf "%s\n" "$entries" | average_length)
    padding=$(get_padding "$avg_len")

    selection=$(printf "%s\n" "$entries" | tofi --prompt-text '' --placeholder-text "$(echo "$base_dir/" | tr -s '/')" \
      --config ~/.config/tofi/config.conf --ascii-input true --padding-left "${padding}%" \
      --padding-top 33% --prompt-padding 0 --num-results 8 \
      --font /usr/share/fonts/TTF/JetBrainsMono-Regular.ttf --require-match false --font-size 16)

    [ -z "$selection" ] && return

    if echo "$entries" | grep -Fxq "$selection"; then
      [ "$selection" = ".." ] && {
        base_dir=$(dirname "$base_dir")
        continue
      }

      full_path="$base_dir/$(echo "$selection" | sed 's:/*$::')"
      [ -d "$full_path" ] && {
        base_dir="$full_path"
        continue
      }
      [ -f "$full_path" ] || [ -L "$full_path" ] && {
        open_file "$full_path"
        return
      }
    else
      results=$(locate -i "$base_dir/**$selection*" 2>/dev/null |
        grep "^$base_dir/" |
        grep -vE '/(\.cache|\.git|\.vscode|\.cargo|\.local/state|\.venv)/')

      [ -z "$results" ] && {
        echo "No results found." | tofi --prompt-text '' --placeholder-text "..." \
          --font /usr/share/fonts/TTF/JetBrainsMono-Regular.ttf \
          --config ~/.config/tofi/config.conf --padding-top 33% --padding-left 40% --font-size 16
        continue
      }

      avg_len=$(printf "%s\n" "$results" | average_length)
      search_padding=$(get_padding "$avg_len")

      selected=$(printf "%s\n" "$results" | tofi --prompt-text '' \
        --placeholder-text "Results matching: $selection" \
        --config ~/.config/tofi/config.conf --ascii-input true --padding-left "${search_padding}%" \
        --padding-top 33% --prompt-padding 0 --num-results 8 \
        --font /usr/share/fonts/TTF/JetBrainsMono-Regular.ttf --font-size 16)

      [ -z "$selected" ] && continue
      [ -d "$selected" ] && {
        base_dir="$selected"
        continue
      }
      [ -f "$selected" ] || [ -L "$selected" ] && {
        open_file "$selected"
        return
      }
    fi
  done
}

browse_dir "$HOME"
