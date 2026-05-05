#!/bin/bash
# Watches macOS low power mode and fires a custom sketchybar event on change.
# Polls because macOS does not expose a public Darwin notification for LPM.

# Kill any prior instance so reloads don't stack watchers.
for pid in $(pgrep -f "lowpower_watcher.sh"); do
  if [[ "$pid" != "$$" && "$pid" != "$PPID" ]]; then
    kill "$pid" 2>/dev/null
  fi
done

last=""
while true; do
  current=$(pmset -g | awk '/^[[:space:]]*powermode/ {print $2}')
  if [[ "$current" != "$last" ]]; then
    sketchybar --trigger power_mode_change 2>/dev/null
    last="$current"
  fi
  sleep 3
done
