#!/bin/bash

# Add a Wi-Fi item to SketchyBar
sketchybar --add item wifi right                         \
           --set wifi script="$PLUGIN_DIR/wifi.sh"      \
                     update_freq=5                     \
                     label.color=$WHITE                 \
                     background.color=$ITEM_BG_COLOR    \
