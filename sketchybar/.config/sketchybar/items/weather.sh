sketchybar --add item weather right \
  --set weather \
  background.color=$ITEM_BG_COLOR \
  label.color=$WHITE \
  update_freq=300 \
  script="$PLUGIN_DIR/weather.sh" \
  --subscribe weather system_woke mouse.clicked
