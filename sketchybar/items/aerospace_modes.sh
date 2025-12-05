#!/bin/bash

modes=(
  icon=$ICON_AEROSAPCE_MAIN_MODE
  icon.padding_left=$PADDINGS
  icon.padding_right=$PADDINGS
  label.padding_right=$PADDINGS
  script="$PLUGIN_DIR/aerospace_modes.sh"
)

# Add custom events for aerospace
sketchybar --add event aerospace_mode_change
sketchybar --add event aerospace_workspace_change
sketchybar --add item aerospace_modes left                     \
           --set aerospace_modes "${modes[@]}"                 \
           --set aerospace_modes "${bracket_defaults[@]}"      \
           --subscribe aerospace_modes aerospace_workspace_change    \
                                 aerospace_mode_change         \
                                 mouse.clicked                 \
                                 front_app_switched
