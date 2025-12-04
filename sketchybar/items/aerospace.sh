#!/bin/bash

aerospace=(
  icon=$ICON_AEROSAPCE_MAIN_MODE
  icon.padding_left=$PADDINGS
  icon.padding_right=$PADDINGS
  label.padding_right=$PADDINGS
  script="$PLUGIN_DIR/aerospace.sh"
)

# Add custom events for aerospace
sketchybar --add event aerospace_mode_change
sketchybar --add event aerospace_workspace_change
sketchybar --add item aerospace left                   \
           --set aerospace "${aerospace[@]}"            \
           --set aerospace "${bracket_defaults[@]}"     \
           --subscribe aerospace aerospace_workspace_change \
                                 aerospace_mode_change  \
                                 mouse.clicked          \
                                 front_app_switched
