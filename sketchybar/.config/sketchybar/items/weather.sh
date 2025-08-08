sketchybar --add item weather left \
  --set weather \
  background.color=$ACCENT_COLOR \
  icon.color=$BAR_COLOR \
  label.color=$BAR_COLOR \
  update_freq=300 \
  script="$PLUGIN_DIR/weather.sh" \
  --subscribe weather system_woke mouse.clicked
