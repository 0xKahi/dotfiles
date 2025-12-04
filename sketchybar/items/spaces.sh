#!/bin/bash

# Load global styles, colors and icons
source "$CONFIG_DIR/globalstyles.sh"

# Defaults
spaces=(
  background.corner_radius=4
  icon.padding_right=8
  label.padding_right=8
  background.padding_left=4
  background.padding_right=4
  background.color=$BAR_COLOR
)

sketchybar --add event aerospace_workspace_change

# Get all non-empty workspaces
SPACES=($(aerospace list-workspaces --all))
for SID in "${SPACES[@]}"; do
  sketchybar --add item space.$SID left                   \
             --set space.$SID "${spaces[@]}"              \
                   script="$PLUGIN_DIR/app_space.sh $SID" \
                   icon=$SID                              \
                   background.drawing=on                 \
                   updates=on                            \
             --subscribe space.$SID mouse.clicked front_app_switched aerospace_workspace_change
done
