#!/bin/bash

# Script to update the Wi-Fi status in SketchyBar

# Fetch Wi-Fi status
wifi_info=$(networksetup -getairportnetwork en0 2>/dev/null)

if [[ $wifi_info == *"You are not associated"* ]]; then
    # Not connected to Wi-Fi
    sketchybar --set $NAME label="Not Connected" icon="􀙈"
else
    # Connected to a network, fetch its name
    wifi_name=$(echo "$wifi_info" | awk -F ': ' '{print $2}')
    sketchybar --set $NAME label="$wifi_name" icon="􀙇"
fi
