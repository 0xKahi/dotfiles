#!/bin/bash

# Load global styles, colors and icons
source "$CONFIG_DIR/globalstyles.sh"

SID=$1
DEBUG=1

create_icons() {
  sketchybar --set space.$1 label="$(create_label "$1")"
}

update_icons() {
  
  CURRENT_SID=$(aerospace list-workspaces --focused)

  # Check if workspace has any windows
  WINDOWS=$(aerospace list-windows --workspace "$SID" --format "%{app-name}")

  BORDER_WIDTH=0
  BACKGROUND_COLOR=$BAR_COLOR
  BORDER_COLOR=$BAR_COLOR
  extra_animate=()

  # Determine drawing state
  # Show workspace if: it has windows OR it's the currently focused workspace
  local SHOULD_DRAW="on"
  if [[ -z "$WINDOWS" ]] && [[ "$CURRENT_SID" != "$SID" ]]; then
    SHOULD_DRAW="off"
  fi

  # Always update the label (create_label now checks if workspace is focused)
  create_icons "$SID"

  # Determine if this workspace should animate
  # Only animate if PREV_AEROSPACE_WORKSPACE is set (workspace change event)
  # and this workspace is involved in the transition
  local SHOULD_ANIMATE=false
  
  if [[ "$CURRENT_SID" == "$SID" ]]; then
    # This is the newly focused workspace
    ICON_COLOR_VALUE=$HIGHLIGHT
    LABEL_COLOR_VALUE=$HIGHLIGHT
    BORDER_COLOR_VALUE=$HIGHLIGHT
    BORDER_WIDTH_VALUE=1
    # Only animate if we know the previous workspace
    if [[ -n "$PREV_AEROSPACE_WORKSPACE" ]]; then
      SHOULD_ANIMATE=true
      extra_animate=(
        y_offset=3
        y_offset=0
      )
    fi
  elif [[ -n "$PREV_AEROSPACE_WORKSPACE" ]] && [[ "$PREV_AEROSPACE_WORKSPACE" == "$SID" ]]; then
    # This was the previously focused workspace (now unfocused)
    ICON_COLOR_VALUE=$ICON_COLOR
    LABEL_COLOR_VALUE=$LABEL_COLOR
    BORDER_COLOR_VALUE=$BORDER_COLOR
    BORDER_WIDTH_VALUE=$BORDER_WIDTH
    SHOULD_ANIMATE=true
  else
    # This workspace is not involved in the transition
    ICON_COLOR_VALUE=$ICON_COLOR
    LABEL_COLOR_VALUE=$LABEL_COLOR
    BORDER_COLOR_VALUE=$BORDER_COLOR
    BORDER_WIDTH_VALUE=$BORDER_WIDTH
    SHOULD_ANIMATE=false
  fi
  
  # Apply changes with or without animation
  if [[ "$SHOULD_ANIMATE" == true ]]; then
    sketchybar --animate tanh 10                                                 \
               --set space.$SID icon.color=$ICON_COLOR_VALUE                     \
                                label.color=$LABEL_COLOR_VALUE                   \
                                background.border_color=$BORDER_COLOR_VALUE      \
                                background.border_width=$BORDER_WIDTH_VALUE      \
                                background.corner_radius=15                      \
                                icon.padding_left=$PADDINGS                      \
                                background.color=$BACKGROUND_COLOR               \
                                icon.padding_right=$PADDINGS                     \
                                "${extra_animate[@]}"                            \
                                drawing=$SHOULD_DRAW
  else
    sketchybar --set space.$SID icon.color=$ICON_COLOR_VALUE                     \
                                label.color=$LABEL_COLOR_VALUE                   \
                                background.border_color=$BORDER_COLOR_VALUE      \
                                background.border_width=$BORDER_WIDTH_VALUE      \
                                background.corner_radius=15                      \
                                icon.padding_left=$PADDINGS                      \
                                background.color=$BACKGROUND_COLOR               \
                                icon.padding_right=$PADDINGS                     \
                                drawing=$SHOULD_DRAW
  fi
}


create_label() {
  SID=$1
  # Get all windows in the workspace
  WINDOWS=$(aerospace list-windows --workspace "$SID" --format "%{app-name}")
  IFS=$'\n'
  local APPS=($(echo "$WINDOWS" | sort -u))
  # Get focused window app
  local CURRENT_APP=$(aerospace list-windows --focused --format "%{app-name}" 2>/dev/null)
  # Get focused workspace
  local FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)
  local LABEL BADGE

  # if [[ $APPS ]]; then
  #   export PADDING_LABEL=$PADDINGS
    for APP in "${APPS[@]}"; do
      # Add icon
      LABEL+=$("$HOME/.config/sketchybar/plugins/app_icon.sh" "$APP")
      # Add app name only if this workspace is focused AND this is the current app
      if [[ "$FOCUSED_WORKSPACE" == "$SID" ]] && [[ "$APP" == "$CURRENT_APP" ]]; then
        LABEL+=" $APP"
      # For unfocused apps…
      else
        # Add a space if there is a badge
        if [[ $BADGE ]]; then
          LABEL+=" "
        fi
      fi
      # Add badge
      LABEL+="$BADGE"
      # Add a space between labels if there is more than one app on a space
      if (( ${#APPS[@]} > 1 )); then
        LABEL+=" "
      fi
    done
    # Remove trailing space if necessary
    if [[ "$LABEL" =~ [[:space:]]$ ]]; then
      LABEL="${LABEL%"${LABEL##*[![:space:]]}"}"
    fi
  # else
    # export PADDING_LABEL=0
    # LABEL=""
  # fi
  echo $LABEL
  unset IFS
}

mouse_clicked() {
  if [[ "$BUTTON" == "right" ]] || [[ "$MODIFIER" == "shift" ]]; then
    SPACE_NAME="${NAME#*.}"
    SPACE_LABEL="$(osascript -e "return (text returned of (display dialog \"Rename space $SPACE_NAME to:\" default answer \"\" with title \"Space Renamer\" buttons {\"Cancel\", \"Rename\"} default button \"Rename\"))")"
    if [[ $? -eq 0 ]]; then
      if [[ "$SPACE_LABEL" == "" ]]; then
        set_space_label "${NAME:6}"
      else
        set_space_label "${NAME:6} $SPACE_LABEL"
      fi
    fi
  else
    aerospace workspace $SID
  fi
}

set_space_label() {
  sketchybar --set $NAME icon="$@"
}

debug() {
  if (( DEBUG == 1 )); then
    echo ---$(date +"%T")---
    echo sender: $SENDER
    echo sid: $SID
    echo ---
    echo $@
    echo ---
  fi
}

case "$SENDER" in
"routine" | "forced" | "space_windows_change")
  create_icons "$SID"
  update_icons
  ;;
"aerospace_workspace_change" | "front_app_switched")
  # Always update all workspaces to ensure proper drawing state
  update_icons
  ;;
"mouse.clicked")
  mouse_clicked
  ;;
esac
