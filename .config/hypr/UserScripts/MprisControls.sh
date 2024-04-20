#!/usr/bin/env bash

# List available players using Rofi
select_player() {
    players=$(playerctl -l)
    num_players=$(echo "$players" | wc -l)
    if [[ "$num_players" -gt 1 ]]; then
        selected=$(echo "$players" | rofi -dmenu -p "Select player:")
        echo "$selected"
    else
        echo "$players"
    fi
}

selected_player=$(select_player)

# Theme Elements
player_status=$(playerctl --player="$selected_player" status 2>/dev/null)
if [[ "$player_status" == "Playing" || "$player_status" == "Paused" ]]; then
    artist=$(playerctl --player="$selected_player" metadata artist)
    song=$(playerctl --player="$selected_player" metadata title)
    prompt="$artist"
    ts=$(playerctl --player="$selected_player" position --format='{{duration(position)}}')
    len=$(playerctl --player="$selected_player" metadata --format='{{duration(mpris:length)}}')
    mesg="$song : $ts / $len"
else
    prompt='Offline'
    mesg="No music playing"
fi

if [[ "$player_status" == "Playing" ]]; then
    option_1="⏸︎"
else
    option_1="⏵︎"
fi
option_2="⏮"
option_3="⏭"
option_4="⏹"

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "listview {columns: 4; lines: 1;}" \
        -theme-str 'textbox-prompt-colon {str: " ";}' \
        -dmenu \
        -p "$prompt" \
        -mesg "$mesg" \
        -markup-rows \
        -theme $HOME/.local/share/rofi/themes/mpris_style.rasi
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$option_1\n$option_2\n$option_3\n$option_4" | rofi_cmd
}

# Execute Command
run_cmd() {
    if [[ "$1" == '--opt1' ]]; then
        playerctl --player="$selected_player" play-pause
    elif [[ "$1" == '--opt2' ]]; then
        playerctl --player="$selected_player" previous
    elif [[ "$1" == '--opt3' ]]; then
        playerctl --player="$selected_player" next
    elif [[ "$1" == '--opt4' ]]; then
        playerctl --player="$selected_player" stop
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
        run_cmd --opt1
        ;;
    $option_2)
        run_cmd --opt2
        ;;
    $option_3)
        run_cmd --opt3
        ;;
    $option_4)
        run_cmd --opt4
        ;;
esac
