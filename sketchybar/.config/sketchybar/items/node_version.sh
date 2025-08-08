#!/bin/bash
# Add a PHP version item to SketchyBar
sketchybar --add item node_version right                  \
           --set node_version script="$PLUGIN_DIR/node_version.sh" \
                     update_freq=3600                    \
                     label.color=$WHITE                  \
                     background.color=$ITEM_BG_COLOR    \
                     icon.font="Hacker Nerd Font Mono:Semibold:18.0"
