#!/bin/bash

# macOS 15.4+ broke sketchybar's built-in media_change event, so we poll
# media-control (https://github.com/ungive/media-control) instead.
INFO="$(media-control get 2>/dev/null)"

# No media session at all
if [ -z "$INFO" ] || [ "$INFO" = "null" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

PLAYING="$(echo "$INFO" | jq -r '.playing')"

if [ "$PLAYING" = "true" ]; then
  TITLE="$(echo "$INFO" | jq -r '.title // ""')"
  ARTIST="$(echo "$INFO" | jq -r '.artist // ""')"

  if [ -n "$ARTIST" ]; then
    MEDIA="$TITLE - $ARTIST"
  else
    MEDIA="$TITLE"
  fi

  sketchybar --set "$NAME" label="$MEDIA" drawing=on
else
  sketchybar --set "$NAME" drawing=off
fi
