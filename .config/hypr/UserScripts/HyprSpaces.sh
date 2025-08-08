#!/bin/nu

def main [cmd: string, number: int] {
    if $number < 1 or $number > 6 {
        error make { msg: "Number must be between 1 and 5" }
    }

    let monitor = (hyprctl monitors -j | from json | where focused == true | get name | first)

    let workspace = if $monitor != "eDP-1" {
        $number + 5
    } else if $monitor == "eDP-1" {
        $number
    }

    match $cmd {
        "switch" => {
            hyprctl dispatch focusworkspaceoncurrentmonitor $workspace
        }
        "move" => {
            hyprctl dispatch movetoworkspace $workspace
        }
    }
}

