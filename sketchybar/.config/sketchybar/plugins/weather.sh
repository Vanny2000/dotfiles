#!/usr/bin/env bash

# Fetch IP and location (lat,long) from ipinfo.io
IPINFO_JSON=$(curl -s "https://ipinfo.io/json")
LOC=$(echo "$IPINFO_JSON" | jq -r '.loc')
CITY=$(echo "$IPINFO_JSON" | jq -r '.city')
LAT="${LOC%,*}"
LON="${LOC#*,}"

# Fallback if location lookup failed
if [ -z "$LOC" ] || [ "$LOC" = "null" ]; then
  sketchybar --set "$NAME" label="UNKNOWN LOCATION"
  exit 1
fi

# Fetch weather data from Open-Meteo
WEATHER_JSON=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&current=temperature_2m,weather_code")

# Fallback if weather data is empty
if [ -z "$WEATHER_JSON" ] || [ "$(echo "$WEATHER_JSON" | jq -r '.current')" = "null" ]; then
  sketchybar --set "$NAME" label="WEATHER UNAVAILABLE"
  exit 1
fi

# Parse weather data
TEMPERATURE=$(echo "$WEATHER_JSON" | jq -r '.current.temperature_2m')
WEATHER_CODE=$(echo "$WEATHER_JSON" | jq -r '.current.weather_code')

# Map WMO weather codes to description and icon
# https://open-meteo.com/en/docs#weather_variable_documentation
case "$WEATHER_CODE" in
  0)
    WEATHER_DESCRIPTION="Clear"
    ICON="􀇔"  # Sun icon
    ;;
  1)
    WEATHER_DESCRIPTION="Mainly clear"
    ICON="􀇔"  # Sun icon
    ;;
  2)
    WEATHER_DESCRIPTION="Partly cloudy"
    ICON="􀇂"  # Cloud icon
    ;;
  3)
    WEATHER_DESCRIPTION="Overcast"
    ICON="􀇂"  # Cloud icon
    ;;
  45 | 48)
    WEATHER_DESCRIPTION="Fog"
    ICON="􀇊"  # Fog icon
    ;;
  51 | 53 | 55)
    WEATHER_DESCRIPTION="Drizzle"
    ICON="􀇄"  # Rain icon
    ;;
  56 | 57)
    WEATHER_DESCRIPTION="Freezing drizzle"
    ICON="􀇄"  # Rain icon
    ;;
  61 | 63 | 65)
    WEATHER_DESCRIPTION="Rain"
    ICON="􀇄"  # Rain icon
    ;;
  66 | 67)
    WEATHER_DESCRIPTION="Freezing rain"
    ICON="􀇄"  # Rain icon
    ;;
  71 | 73 | 75 | 77)
    WEATHER_DESCRIPTION="Snow"
    ICON="􀇎"  # Snowflake icon
    ;;
  80 | 81 | 82)
    WEATHER_DESCRIPTION="Rain showers"
    ICON="􀇄"  # Rain icon
    ;;
  85 | 86)
    WEATHER_DESCRIPTION="Snow showers"
    ICON="􀇎"  # Snowflake icon
    ;;
  95)
    WEATHER_DESCRIPTION="Thunderstorm"
    ICON="􀇒"  # Thunderstorm icon
    ;;
  96 | 99)
    WEATHER_DESCRIPTION="Thunderstorm w/ hail"
    ICON="􀇒"  # Thunderstorm icon
    ;;
  *)
    WEATHER_DESCRIPTION="Unknown"
    ICON="􂬮"  # Default icon (question mark)
    ;;
esac

# Update SketchyBar with weather information and icon
sketchybar --set "$NAME" label="${TEMPERATURE}°C • $WEATHER_DESCRIPTION" icon="$ICON"
