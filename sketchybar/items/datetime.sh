#!/bin/bash

datetime=(
  icon=$ICON_CALENDAR
  icon.drawing=on
  icon.font="$FONT:Bold:13"
  icon.padding_right=1
  icon.color=$(getcolor bright_blue)          
  icon.y_offset=1.5
  label.color=$(getcolor bright_white)
  label.font="$FONT:ExtraBold:12.5"
  padding_right=$PADDINGS
  update_freq=60                     
  script="sketchybar --set \$NAME label=\"\$(date +'%a %d %b %I:%M %p')\""
)

sketchybar                                      \
  --add item datetime right                     \
  --set datetime "${datetime[@]}"               \
  --subscribe datetime system_woke              \
                   mouse.entered                \
                   mouse.exited                 \
                   mouse.exited.global          
