#!/bin/bash

# Use a temp file for storing the current player
CURRENT_PLAYER_FILE="/tmp/mpris_current_player"

# Function to get current player
get_current_player() {
    CURRENT_PLAYER=$(cat "$CURRENT_PLAYER_FILE" 2>/dev/null || echo "")
    
    # If no current player set, find the first active one
    if [ -z "$CURRENT_PLAYER" ] || ! playerctl -p "$CURRENT_PLAYER" status &>/dev/null; then
        CURRENT_PLAYER=$(playerctl -l 2>/dev/null | head -n1)
        [ -n "$CURRENT_PLAYER" ] && echo "$CURRENT_PLAYER" > "$CURRENT_PLAYER_FILE" 2>/dev/null
    fi
    
    echo "$CURRENT_PLAYER"
}

# Handle command line arguments
case "$1" in
    "play-toggle")
        CURRENT_PLAYER=$(get_current_player)
        if [ -n "$CURRENT_PLAYER" ]; then
            playerctl -p "$CURRENT_PLAYER" play-pause 2>/dev/null
            # Refresh the module after toggle
            pkill -SIGRTMIN+8 waybar
        fi
        ;;
    "switch-player")
        # Switch to next available player
        CURRENT_PLAYER=$(get_current_player)
        mapfile -t PLAYERS < <(playerctl -l 2>/dev/null)
        
        if [ ${#PLAYERS[@]} -gt 1 ]; then
            for i in "${!PLAYERS[@]}"; do
                if [ "${PLAYERS[$i]}" = "$CURRENT_PLAYER" ]; then
                    NEXT_INDEX=$(( (i + 1) % ${#PLAYERS[@]} ))
                    echo "${PLAYERS[$NEXT_INDEX]}" > "$CURRENT_PLAYER_FILE"
                    pkill -SIGRTMIN+8 waybar
                    break
                fi
            done
        fi
        ;;
    *)
        # Default case: return JSON with display text and tooltip
        CURRENT_PLAYER=$(get_current_player)
        
        # Get display text (play/pause button)
        if [ -n "$CURRENT_PLAYER" ]; then
            STATUS=$(playerctl -p "$CURRENT_PLAYER" status 2>/dev/null)
            case "$STATUS" in
                "Playing") TEXT="⏸" ;;
                "Paused") TEXT="▶" ;;
                *) TEXT="⏹" ;;
            esac
        else
            TEXT="♪"
        fi
        
        # Get tooltip text
        if [ -n "$CURRENT_PLAYER" ]; then
            TITLE=$(playerctl -p "$CURRENT_PLAYER" metadata title 2>/dev/null)
            ARTIST=$(playerctl -p "$CURRENT_PLAYER" metadata artist 2>/dev/null)
            PLAYER_NAME=$(echo "$CURRENT_PLAYER" | sed 's/org.mpris.MediaPlayer2.//' | sed 's/.instance[0-9]*//')
            
            for v in TITLE ARTIST PLAYER_NAME; do
                eval "$v=\$(echo \"\$$v\" | sed 's/&/\\&amp;/g')"
            done
            MAX_LENGTH=50
            for v in TITLE ARTIST; do
                eval "val=\$$v"
                [ ${#val} -gt $MAX_LENGTH ] && eval "$v=\${val:0:\$((MAX_LENGTH-3))}..."
            done
            
            # Truncate player name to keep it short
            PLAYER_MAX_LENGTH=15
            [ ${#PLAYER_NAME} -gt $PLAYER_MAX_LENGTH ] && PLAYER_NAME="${PLAYER_NAME:0:$((PLAYER_MAX_LENGTH-3))}..."
            
            # Dynamic centering based on title length
            if [ -n "$TITLE" ]; then
                WIDTH=$(( ${#TITLE} + 10 ))  # Base width on title + padding
                [ $WIDTH -lt 30 ] && WIDTH=30  # Minimum width
            else
                WIDTH=30
            fi
            
            # Center text function with dynamic width
            center() { local p=$(( (WIDTH - ${#1}) / 2 )); [ $p -gt 0 ] && printf "%*s%s%*s" $p "" "$1" $p "" || echo "$1"; }
            
            if [ -n "$TITLE" ]; then
                if [ -n "$ARTIST" ]; then
                    # Calculate visual length for centering (artist + player name)
                    ARTIST_PLAYER_TEXT="$ARTIST ($PLAYER_NAME)"
                    ARTIST_PLAYER_LEN=${#ARTIST_PLAYER_TEXT}
                    PADDING=$(( (WIDTH - ARTIST_PLAYER_LEN) / 2 ))
                    [ $PADDING -gt 0 ] && ARTIST_PLAYER_CENTERED=$(printf "%*s<span color='#89dceb'>%s</span> <span color='#6272a4'>(%s)</span>" $PADDING "" "$ARTIST" "$PLAYER_NAME") || ARTIST_PLAYER_CENTERED="<span color='#8be9fd'>$ARTIST</span> <span color='#6272a4'>($PLAYER_NAME)</span>"
                    
                    TITLE_CENTERED=$(center "$TITLE")
                    TOOLTIP="<span color='#f38ba8' weight='bold'>${TITLE_CENTERED}</span>\n$ARTIST_PLAYER_CENTERED"
                else
                    TITLE_CENTERED=$(center "$TITLE")
                    PLAYER_CENTERED=$(center "($PLAYER_NAME)")
                    TOOLTIP="<span color='#f38ba8' weight='bold'>${TITLE_CENTERED}</span>\n<span color='#6272a4'>${PLAYER_CENTERED}</span>"
                fi
            else
                TOOLTIP="<span color='#f8f8f2'>$(center "No track info ($PLAYER_NAME)")</span>"
            fi
        else
            TOOLTIP="<span color='#6272a4'>No media player</span>"
        fi
        
        # Output JSON
        echo "{\"text\":\"$TEXT\",\"tooltip\":\"$TOOLTIP\"}"
        ;;
esac
