#!/bin/bash

sketchybar --add item cpu left \
           --set cpu  update_freq=2 \
                      icon=􀧓  \
                      background.color=$ACCENT_COLOR \
                      icon.color=$BAR_COLOR \
                      label.color=$BAR_COLOR \
                      script="$PLUGIN_DIR/cpu.sh"
