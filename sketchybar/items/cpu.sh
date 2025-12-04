#!/bin/bash

cpu_percent=(
  label.font="$FONT:Bold:12"
  label=$(sysctl -n machdep.cpu.loadavg | awk '{print int($2 * 100)}')% #currently dosent work
  label.color="$LABEL_COLOR"
  icon="$ICON_CPU"
  icon.color="$(getcolor red)"
  icon.font="$FONT:Bold:12"
  update_freq=2
)

sketchybar --add item cpu.percent right	\
  --set cpu.percent "${cpu_percent[@]}"
