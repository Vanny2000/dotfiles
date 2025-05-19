#!/bin/bash
node_version=$(node -v)

# Check if node is installed
if [ -z "$node_version" ]; then
    sketchybar --set $NAME label="Node not found" icon="󰎙"
else
    # Truncate version if it's too long
    if [ ${#node_version} -gt 8 ]; then
        node_version="${node_version:0:5}"
    fi

    sketchybar --set $NAME label="$node_version" icon="󰎙"
fi
