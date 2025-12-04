#!/bin/bash

# Loads defined colors
source "$CONFIG_DIR/colors.sh"

CURRENT_WIFI="$(ipconfig getsummary en0)"
IP_ADDRESS="$(echo "$CURRENT_WIFI" | grep -o "ciaddr = .*" | sed 's/^ciaddr = //')"
SSID="$(echo "$CURRENT_WIFI" | grep -o "SSID : .*" | sed 's/^SSID : //' | tail -n 1)"

# Detect if connected to a hotspot (iPhone/Android tethering)
IS_HOTSPOT="false"
if [[ "$IP_ADDRESS" == 172.20.10.* ]] || echo "$CURRENT_WIFI" | grep -q "IsExpensive : TRUE"; then
  IS_HOTSPOT="true"
fi

if [[ "$IS_HOTSPOT" == "true" ]]; then
  ICON_COLOR=$(getcolor teal)
  ICON=􀉤
elif [[ $SSID != "" ]]; then
  ICON_COLOR=$(getcolor white)
  ICON=󰖩
elif [[ $CURRENT_WIFI = "AirPort: Off" ]]; then
  ICON_COLOR=$(getcolor maroon)
  ICON=󰖪
else
  ICON_COLOR=$(getcolor maroon)
  ICON=󰖪
fi

render_bar_item() {
  DRAWING=$([ "$(cat /tmp/sketchybar_sender)" == "focus_on" ] && echo "off" || echo "on")
  sketchybar --set $NAME \
    icon.color=$ICON_COLOR \
    icon=$ICON \
    drawing=$DRAWING
}

render_popup() {
  if [ "$SSID" != "" ]; then
    args=(
      --set wifi.ssid label="$SSID"
      --set wifi.ipaddress label="$IP_ADDRESS"
      click_script="printf $IP_ADDRESS | pbcopy;sketchybar --set wifi popup.drawing=toggle"
    )
  else
    args=(
      --set wifi.ssid label="Not connected"
      --set wifi.ipaddress label="No IP"
      )
  fi

  sketchybar "${args[@]}" >/dev/null
}

update() {
  render_bar_item
  render_popup
}

popup() {
  sketchybar --set "$NAME" popup.drawing="$1"
}

case "$SENDER" in
"routine" | "forced")
  update
  ;;
"mouse.clicked")
  popup toggle
  ;;
esac
