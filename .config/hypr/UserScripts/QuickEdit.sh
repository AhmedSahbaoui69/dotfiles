#!/bin/bash
# Rofi menu for Quick Edit / View of Settings (SUPER E)

configs="$HOME/.config/hypr/configs"
UserConfigs="$HOME/.config/hypr/UserConfigs"

menu(){
  printf "1.  Environment Variables\n"
  printf "2.  Window Rules\n"
  printf "3.  Startup Apps\n"
  printf "4.  Keybinds\n"
  printf "5.  Monitors\n"
  printf "6.  Hyprland Settings\n"
}

main() {
    choice=$(menu | rofi -dmenu -p "Quick Edit" | cut -d. -f1)
    case $choice in
        1)
            kitty -e nvim "$UserConfigs/ENVariables.conf"
            ;;
        2)
            kitty -e nvim "$UserConfigs/WindowRules.conf"
            ;;
        3)
            kitty -e nvim "$UserConfigs/Startup_Apps.conf"
            ;;
        4)
            kitty -e nvim "$UserConfigs/UserKeybinds.conf"
            ;;
        5)
            kitty -e nvim "$UserConfigs/Monitors.conf"
            ;;
        6)
            kitty -e nvim "$UserConfigs/UserSettings.conf"
            ;;
        *)
            ;;
    esac
}

main
