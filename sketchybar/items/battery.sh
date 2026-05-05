#!/bin/bash

battery=(
  icon.font.size=14
  icon.padding_right=0
  icon.font.style="Light"
  update_freq=60                                             
  popup.align=right                                            
  script="$PLUGIN_DIR/battery.sh"                              
  label.font="$FONT:Regular:12"
  updates=when_shown                                           
)

sketchybar --add event power_mode_change

sketchybar                                 \
  --add item battery right                 \
  --set battery "${battery[@]}"            \
  --subscribe battery power_source_change  \
                      power_mode_change    \
                      mouse.clicked

# Launch background watcher for low power mode changes
"$PLUGIN_DIR/lowpower_watcher.sh" >/dev/null 2>&1 &
disown
