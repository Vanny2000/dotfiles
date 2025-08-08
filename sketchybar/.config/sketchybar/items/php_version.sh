#!/bin/bash
# Add a PHP version item to SketchyBar
sketchybar --add item php_version right                  \
           --set php_version script="$PLUGIN_DIR/php_version.sh" \
                     update_freq=3600                    \
                     label.color=$WHITE                  \
                     background.color=$ITEM_BG_COLOR    \
                     icon.font="Hacker Nerd Font Mono:Semibold:24.0"
