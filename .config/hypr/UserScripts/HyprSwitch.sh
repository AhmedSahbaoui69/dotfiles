#!/usr/bin/env bash

monitors=($(hyprctl -j monitors | jq -r '.[].name'))
[ ${#monitors[@]} -ne 2 ] && exit 0

ws1=$(hyprctl -j monitors | jq -r --arg m "${monitors[0]}" '.[] | select(.name==$m) | .activeWorkspace.id')
ws2=$(hyprctl -j monitors | jq -r --arg m "${monitors[1]}" '.[] | select(.name==$m) | .activeWorkspace.id')

count_ws1=$(hyprctl -j clients | jq "[.[] | select(.workspace.id==$ws1 and .floating==false)] | length")
count_ws2=$(hyprctl -j clients | jq "[.[] | select(.workspace.id==$ws2 and .floating==false)] | length")

focused=$(hyprctl -j activewindow | jq -r '.address')

if [ $count_ws1 -eq 1 ] && [ $count_ws2 -eq 1 ]; then
  win1=$(hyprctl -j clients | jq -r ".[] | select(.workspace.id==$ws1 and .floating==false) | .address")
  win2=$(hyprctl -j clients | jq -r ".[] | select(.workspace.id==$ws2 and .floating==false) | .address")
  hyprctl dispatch movetoworkspacesilent $ws2,address:$win1
  hyprctl dispatch movetoworkspacesilent $ws1,address:$win2

elif [ $count_ws1 -gt 1 ] && [ $count_ws2 -eq 1 ]; then
  win2=$(hyprctl -j clients | jq -r ".[] | select(.workspace.id==$ws2 and .floating==false) | .address")
  hyprctl dispatch movetoworkspacesilent $ws2,address:$focused
  hyprctl dispatch movetoworkspacesilent $ws1,address:$win2

elif [ $count_ws2 -gt 1 ] && [ $count_ws1 -eq 1 ]; then
  win1=$(hyprctl -j clients | jq -r ".[] | select(.workspace.id==$ws1 and .floating==false) | .address")
  hyprctl dispatch movetoworkspacesilent $ws1,address:$focused
  hyprctl dispatch movetoworkspacesilent $ws2,address:$win1
fi
