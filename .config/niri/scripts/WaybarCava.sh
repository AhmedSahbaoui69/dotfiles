#!/bin/sh

CURRENT_PLAYER_FILE="/tmp/mpris_current_player"

# Function to get current track info hash
get_track_hash() {
    CURRENT_PLAYER=$(get_current_player)
    if [ -n "$CURRENT_PLAYER" ]; then
        playerctl -p "$CURRENT_PLAYER" metadata --format "{{title}}|{{artist}}|{{album}}" 2>/dev/null | md5sum | cut -d' ' -f1
    fi
}

# Function to get current player
get_current_player() {
    CURRENT_PLAYER=$(cat "$CURRENT_PLAYER_FILE" 2>/dev/null)
    
    if [ -z "$CURRENT_PLAYER" ] || ! playerctl -p "$CURRENT_PLAYER" status &>/dev/null; then
        CURRENT_PLAYER=$(playerctl -l 2>/dev/null | head -n1)
        [ -n "$CURRENT_PLAYER" ] && echo "$CURRENT_PLAYER" > "$CURRENT_PLAYER_FILE" 2>/dev/null
    fi
    
    echo "$CURRENT_PLAYER"
}

# HTML escape function
html_escape() { echo "$1" | sed 's/&/\&amp;/g'; }

# Center text function
center() { 
    local p=$(( (WIDTH - ${#1}) / 2 ))
    [ $p -gt 0 ] && printf "%*s%s%*s" $p "" "$1" $p "" || echo "$1"
}

# Function to get tooltip with media info
get_tooltip() {
    CURRENT_PLAYER=$(get_current_player)
    
    if [ -n "$CURRENT_PLAYER" ]; then
        # Get metadata directly without splitting
        TITLE=$(playerctl -p "$CURRENT_PLAYER" metadata title 2>/dev/null || echo "")
        ARTIST=$(playerctl -p "$CURRENT_PLAYER" metadata artist 2>/dev/null || echo "")
        ALBUM=$(playerctl -p "$CURRENT_PLAYER" metadata album 2>/dev/null || echo "")
        
        # If title is empty, try to get filename from xesam:url
        if [ -z "$TITLE" ] || [ "$TITLE" = "" ]; then
            URL=$(playerctl -p "$CURRENT_PLAYER" metadata xesam:url 2>/dev/null || echo "")
            if [ -n "$URL" ] && [ "$URL" != "" ]; then
                # Extract filename (last part after /)
                TITLE=$(echo "$URL" | sed 's|.*/||')
                # Remove URL encoding if present (basic decoding)
                TITLE=$(echo "$TITLE" | sed 's/%20/ /g; s/%2B/+/g; s/%26/\&/g; s/%27/'"'"'/g')
            fi
        fi
        
        # Set defaults for missing fields - be more explicit about empty checks
        if [ -z "$TITLE" ] || [ "$TITLE" = "" ]; then
            TITLE="Unknown"
        fi
        if [ -z "$ARTIST" ] || [ "$ARTIST" = "" ]; then
            ARTIST="Unknown"
        fi
        if [ -z "$ALBUM" ] || [ "$ALBUM" = "" ]; then
            ALBUM="Unknown"
        fi
        
        TITLE=$(html_escape "$TITLE")
        ARTIST=$(html_escape "$ARTIST")
        ALBUM=$(html_escape "$ALBUM")
        PLAYER_NAME=$(html_escape "$(echo "$CURRENT_PLAYER" | sed 's/org.mpris.MediaPlayer2.//;s/.instance[0-9]*//')")
        
        # Truncate strings
        [ ${#TITLE} -gt 50 ] && TITLE="${TITLE:0:47}..."
        [ ${#ARTIST} -gt 50 ] && ARTIST="${ARTIST:0:47}..."
        [ ${#ALBUM} -gt 40 ] && ALBUM="${ALBUM:0:37}..."
        [ ${#PLAYER_NAME} -gt 15 ] && PLAYER_NAME="${PLAYER_NAME:0:12}..."
        
        # Set width for centering
        WIDTH=$(( ${#TITLE} + 10 ))
        [ $WIDTH -lt 35 ] && WIDTH=35
        
        TITLE_CENTERED=$(center "$TITLE")
        TOOLTIP="<span color='#f38ba8' weight='bold'>${TITLE_CENTERED}</span>"
        
        # Add artist and/or album info - show what's available
        if [ "$ARTIST" != "Unknown" ] && [ "$ALBUM" != "Unknown" ]; then
            # Both available - show "Artist - Album"
            ARTIST_ALBUM="$ARTIST - $ALBUM"
            ARTIST_ALBUM_LEN=$(( ${#ARTIST_ALBUM} + ${#PLAYER_NAME} + 3 ))
            PADDING=$(( (WIDTH - ARTIST_ALBUM_LEN) / 2 ))
            if [ $PADDING -gt 0 ]; then
                TOOLTIP="$TOOLTIP\n$(printf "%*s<span color='#89dceb'>%s</span> <span color='#6272a4'>(%s)</span>" $PADDING "" "$ARTIST_ALBUM" "$PLAYER_NAME")"
            else
                TOOLTIP="$TOOLTIP\n<span color='#89dceb'>$ARTIST_ALBUM</span> <span color='#6272a4'>($PLAYER_NAME)</span>"
            fi
        elif [ "$ARTIST" != "Unknown" ]; then
            # Only artist available
            ARTIST_LEN=$(( ${#ARTIST} + ${#PLAYER_NAME} + 3 ))
            PADDING=$(( (WIDTH - ARTIST_LEN) / 2 ))
            if [ $PADDING -gt 0 ]; then
                TOOLTIP="$TOOLTIP\n$(printf "%*s<span color='#89dceb'>%s</span> <span color='#6272a4'>(%s)</span>" $PADDING "" "$ARTIST" "$PLAYER_NAME")"
            else
                TOOLTIP="$TOOLTIP\n<span color='#89dceb'>$ARTIST</span> <span color='#6272a4'>($PLAYER_NAME)</span>"
            fi
        elif [ "$ALBUM" != "Unknown" ]; then
            # Only album available
            ALBUM_LEN=$(( ${#ALBUM} + ${#PLAYER_NAME} + 3 ))
            PADDING=$(( (WIDTH - ALBUM_LEN) / 2 ))
            if [ $PADDING -gt 0 ]; then
                TOOLTIP="$TOOLTIP\n$(printf "%*s<span color='#cba6f7'>%s</span> <span color='#6272a4'>(%s)</span>" $PADDING "" "$ALBUM" "$PLAYER_NAME")"
            else
                TOOLTIP="$TOOLTIP\n<span color='#cba6f7'>$ALBUM</span> <span color='#6272a4'>($PLAYER_NAME)</span>"
            fi
        else
            # Neither available - show "Unknown"
            UNKNOWN_LEN=$(( 7 + ${#PLAYER_NAME} + 3 ))  # "Unknown" = 7 chars
            PADDING=$(( (WIDTH - UNKNOWN_LEN) / 2 ))
            if [ $PADDING -gt 0 ]; then
                UPDATED_TOOLTIP=$(printf "%*s<span color='#89dceb'>Unknown</span><span color='#6272a4'> (%s)</span>" $PADDING "" "$PLAYER_NAME")
                TOOLTIP="$TOOLTIP\n$UPDATED_TOOLTIP"
            else
                TOOLTIP="$TOOLTIP\n<span color='#89dceb'>Unknown</span><span color='#6272a4'>($PLAYER_NAME)</span>"
            fi
        fi
    else
        TOOLTIP="<span color='#6272a4'>No media player</span>"
    fi
    
    echo "$TOOLTIP"
}

# Handle command line arguments
case "$1" in
    "play-toggle")
        CURRENT_PLAYER=$(get_current_player)
        [ -n "$CURRENT_PLAYER" ] && {
            playerctl -p "$CURRENT_PLAYER" play-pause 2>/dev/null
            pkill -SIGRTMIN+9 waybar
        }
        ;;
    "switch-player")
        CURRENT_PLAYER=$(get_current_player)
        mapfile -t PLAYERS < <(playerctl -l 2>/dev/null)
        
        [ ${#PLAYERS[@]} -gt 1 ] && {
            for i in "${!PLAYERS[@]}"; do
                [ "${PLAYERS[$i]}" = "$CURRENT_PLAYER" ] && {
                    echo "${PLAYERS[$(( (i + 1) % ${#PLAYERS[@]} ))]}" > "$CURRENT_PLAYER_FILE"
                    pkill -SIGRTMIN+9 waybar
                    break
                }
            done
        }
        ;;
    *)
        # Cava visualization with media tooltip
        bar="▁▂▃▄▅▆▇█"
        dict="s/;//g"
        for ((i = 0; i < ${#bar}; i++)); do
            dict+=";s/$i/${bar:$i:1}/g"
        done

        config_file="/tmp/bar_cava_config"
        cat >"$config_file" <<EOF
[general]
bars = 10
[input]
method = pulse
source = auto
[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

        pkill -f "cava -p $config_file"

        TOOLTIP_CACHE="/tmp/waybar_cava_tooltip_cache"
        TOOLTIP_TIMESTAMP="/tmp/waybar_cava_tooltip_timestamp"
        TRACK_HASH_FILE="/tmp/waybar_cava_track_hash"
        
        get_tooltip > "$TOOLTIP_CACHE"
        get_track_hash > "$TRACK_HASH_FILE"
        date +%s > "$TOOLTIP_TIMESTAMP"
        
        counter=0

        cava -p "$config_file" | sed -u "$dict" | while IFS= read -r line; do
            [ $((counter % 20)) -eq 0 ] && {
                CURRENT_HASH=$(get_track_hash)
                CACHED_HASH=$(cat "$TRACK_HASH_FILE" 2>/dev/null)
                
                if [ "$CURRENT_HASH" != "$CACHED_HASH" ] || [ "$CURRENT_PLAYER_FILE" -nt "$TOOLTIP_TIMESTAMP" ] 2>/dev/null; then
                    get_tooltip > "$TOOLTIP_CACHE"
                    echo "$CURRENT_HASH" > "$TRACK_HASH_FILE"
                    date +%s > "$TOOLTIP_TIMESTAMP"
                fi
                TOOLTIP=$(cat "$TOOLTIP_CACHE" 2>/dev/null || echo '<span color="#6272a4">No media player</span>')
            }
            echo "{\"text\":\"$line\",\"tooltip\":\"$TOOLTIP\"}"
            counter=$((counter + 1))
        done
        ;;
esac
