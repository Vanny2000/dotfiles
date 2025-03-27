#!/bin/bash

sketchybar --add item cpu left \
           --set cpu  update_freq=2 \
                      icon=􀧓  \
                      background.color=$ITEM_BG_COLOR \
                      icon.color=$WHITE \
                      label.color=$WHITE \
                      script="$PLUGIN_DIR/cpu.sh"
