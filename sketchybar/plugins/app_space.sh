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
  
  # Determine drawing state
  # Show workspace if: it has windows OR it's the currently focused workspace
  local SHOULD_DRAW="on"
  if [[ -z "$WINDOWS" ]] && [[ "$CURRENT_SID" != "$SID" ]]; then
    SHOULD_DRAW="off"
  fi

  # Always update the label (create_label now checks if workspace is focused)
  create_icons "$SID"

  if [[ "$CURRENT_SID" == "$SID" ]]; then
    # Focused workspace - highlight the workspace number and label
    ICON_COLOR=$HIGHLIGHT
    LABEL_COLOR=$HIGHLIGHT
    BACKGROUND_COLOR=$BAR_COLOR

    ## For hihlighted background
    # ICON_COLOR="$(getcolor trueblack)"
    # LABEL_COLOR="$(getcolor trueblack)"
    # BACKGROUND_COLOR=$HIGHLIGHT
  else
    # Unfocused workspace - normal colors
    ICON_COLOR=$ICON_COLOR
    LABEL_COLOR=$LABEL_COLOR
    # BACKGROUND_COLOR="$(getcolor white 10)" # transaparent
    BACKGROUND_COLOR=$BAR_COLOR
  fi
  
  # echo $CURRENT_SID ">" $CURRENT_LABEL ">" $PADDING_LABEL

  sketchybar --animate tanh 10                                    \
             --set space.$SID icon.color=$ICON_COLOR              \
                              label.color=$LABEL_COLOR            \
                              background.corner_radius=15         \
                              icon.padding_left=$PADDINGS         \
                              background.color=$BACKGROUND_COLOR   \
                              icon.padding_right=$PADDINGS          \
                              drawing=$SHOULD_DRAW
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
