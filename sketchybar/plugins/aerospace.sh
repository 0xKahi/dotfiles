#!/bin/bash

# Load global styles, colors and icons
source "$CONFIG_DIR/globalstyles.sh"

set_icon() {
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
  FRONT_APP_LABEL_COLOR="$(sketchybar --query space.$FOCUSED_WORKSPACE | jq -r ".label.highlight_color")"
  
  # Get current aerospace mode
  MODE=$(aerospace list-modes --current 2>/dev/null || echo "main")
  COLOR=$ICON_COLOR

  # Determine icon based on mode
  # Aerospace modes: main, service, resize, window
  if [[ $MODE == "main" ]]; then
    ICON=$ICON_AEROSAPCE_MAIN_MODE
    COLOR=$ICON_COLOR
    BG_COLOR=$BAR_COLOR
    LABEL=""
  elif [[ $MODE == "service" ]]; then
    ICON=$ICON_AEROSAPCE_SERVICE_MODE
    COLOR=$(getcolor trueblack)
    BG_COLOR=$(getcolor red)
    LABEL=""
  elif [[ $MODE == "resize" ]]; then
    ICON=$ICON_AEROSAPCE_RESIZE_MODE
    COLOR=$(getcolor trueblack)
    BG_COLOR=$(getcolor purple)
    LABEL=""
  elif [[ $MODE == "window" ]]; then
    ICON=$ICON_AEROSAPCE_WINDOW_MODE
    COLOR=$(getcolor trueblack)
    BG_COLOR=$(getcolor green)
    LABEL=""
  else
    ICON=$ICON_AEROSAPCE_MAIN_MODE
    COLOR=$ICON_COLOR
    LABEL=""
  fi

  args=(--bar border_color=$COLOR --animate tanh 10 --set $NAME icon=$ICON icon.color=$COLOR background.color=$BG_COLOR)

  # [ -z "$LABEL" ] && args+=(label.drawing=off) ||
  #   args+=(label.drawing=off label.padding_right=0  label.color=$COLOR)

  [ -z "$ICON" ] && args+=(icon.width=0) ||
    args+=(icon=$ICON icon.font="$FONT:ExtraBold:20" label.drawing=off)

  sketchybar -m "${args[@]}"
}

mouse_clicked() {
  # Refresh icon on click
  set_icon
}

case "$SENDER" in
  "mouse.clicked")
    mouse_clicked
    ;;
  "front_app_switched" | "aerospace_workspace_change" | "aerospace_mode_change")
    set_icon
    ;;
esac
