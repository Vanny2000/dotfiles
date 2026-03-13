#!/bin/bash

# Script to update the Wi-Fi status in SketchyBar

# Check if Wi-Fi has an IP address (reliable connection check)
ip_address=$(ipconfig getifaddr en0 2>/dev/null)

if [[ -z "$ip_address" ]]; then
    sketchybar --set $NAME label="Not Connected" icon="􀙈"
else
    # Try networksetup first (works on some macOS versions)
    wifi_name=$(/usr/sbin/ipconfig getsummary en0 | awk -F' : ' '/ SSID/ { print $2 }')

    # Fallback: show IP address if SSID is unavailable (macOS privacy restriction)
    if [[ -z "$wifi_name" ]]; then
        wifi_name="$ip_address"
    fi

    sketchybar --set $NAME label="$wifi_name" icon="􀙇"
fi
