#!/usr/bin/env bash

# Fetch IP and location
IP=$(curl -s https://ipinfo.io/ip)
LOCATION=$(curl -s https://ipinfo.io/"$IP"/json | jq '.ip' | tr -d '"')

# Fetch weather data in JSON format
WEATHER_JSON=$(curl -s "https://wttr.in/$LOCATION?format=j1")

# Fallback if weather data is empty
if [ -z "$WEATHER_JSON" ]; then
  sketchybar --set "$NAME" label="UNKNOWN LOCATION"
  exit 1
fi

# Parse weather data
CITY="$(echo "$WEATHER_JSON" | jq '.nearest_area[0].areaName[].value' | tr -d '"')"
REGION="$(echo "$WEATHER_JSON" | jq '.nearest_area[0].region[].value' | tr -d '"')"
TEMPERATURE=$(echo "$WEATHER_JSON" | jq '.current_condition[0].temp_C' | tr -d '"')
WEATHER_DESCRIPTION=$(echo "$WEATHER_JSON" | jq '.current_condition[0].weatherDesc[0].value' | tr -d '"' | sed 's/\(.\{25\}\).*/\1.../')

# Map weather conditions to icons
case "$WEATHER_DESCRIPTION" in
  *sunny* | *clear*)
    ICON="􀇔"  # Sun icon
    ;;
  *cloudy* | *overcast*)
    ICON="􀇂"  # Cloud icon
    ;;
  *rain* | *drizzle* | *showers*)
    ICON="􀇄"  # Rain icon
    ;;
  *thunderstorm*)
    ICON="􀇒"  # Thunderstorm icon
    ;;
  *snow*)
    ICON="􀇎"  # Snowflake icon
    ;;
  *fog* | *mist*)
    ICON="􀇊"  # Fog icon
    ;;
  *)
    ICON="􂬮"  # Default icon (question mark)
    ;;
esac

# Update SketchyBar with weather information and icon
sketchybar --set "$NAME" label="${TEMPERATURE}°C • $WEATHER_DESCRIPTION" icon="$ICON" 
