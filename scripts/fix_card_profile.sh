#!/bin/bash

# Get the output of the command
output=$(pactl list cards short)

# Extract the first number from the output
card_number=$(echo "$output" | awk '{print $1; exit}')

# Set the card profile using the extracted number
pactl set-card-profile "$card_number" 'HiFi (HDMI1, HDMI2, HDMI3, Mic1, Mic2, Speaker)'

# Set default sink
pactl set-default-sink alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink
