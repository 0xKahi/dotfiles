#!/bin/bash

# Load global styles, colors and icons
source "$CONFIG_DIR/globalstyles.sh"

CACHE_FILE="/tmp/sketchybar_github_prs.json"
LOCK_FILE="/tmp/sketchybar_github_prs.lock"
POPUP_OFF="sketchybar --set github_prs popup.drawing=off"
GH_SCRIPT="$SKETCHY_SCRIPT_DIR/gh-pr.sh"

check_wifi() {
  CURRENT_WIFI="$(ipconfig getsummary en0)"
  IP_ADDRESS="$(echo "$CURRENT_WIFI" | grep -o "ciaddr = .*" | sed 's/^ciaddr = //')"
  
  if [ "$IP_ADDRESS" != "" ]; then
    return 0
  else
    return 1
  fi
}

cleanup_old_pr_items() {
  # Remove all existing PR items from popup
  sketchybar --remove '/github_prs\.pr_.*/' 2>/dev/null
}

fetch_prs() {
  # Check for lock file to prevent concurrent fetches
  if [ -f "$LOCK_FILE" ]; then
    return 1
  fi
  
  # Create lock file
  touch "$LOCK_FILE"
  
  # Show loading state
  sketchybar --set github_prs label="..." label.drawing=on
  # Hide status items during loading
  sketchybar --set github_prs.failed drawing=off \
             --set github_prs.passed drawing=off \
             --set github_prs.pending drawing=off
  
  # Fetch PR data with 30 second timeout using perl
  # PR_DATA=$(perl -e 'alarm 30; exec @ARGV' "$GH_SCRIPT" --filter "shuffle-labs,cadillac-studios" 2>&1)
  PR_DATA=$(perl -e 'alarm 30; exec @ARGV' /Users/kahi/dotfiles/sketchybar/scripts/gh-pr.sh --filter "shuffle-labs,cadillac-studios" 2>&1)
  EXIT_CODE=$?
  
  # Remove lock file
  rm -f "$LOCK_FILE"
  
  # Check for timeout (exit code 142 = SIGALRM)
  if [ $EXIT_CODE -eq 142 ] || [ $EXIT_CODE -eq 124 ]; then
    echo "error_timeout" > "$CACHE_FILE"
    return 1
  fi
  
  # Check for command error
  if [ $EXIT_CODE -ne 0 ]; then
    echo "error_command" > "$CACHE_FILE"
    return 1
  fi
  
  # Validate JSON (jojo already uses jq, but let's ensure it's valid)
  if ! echo "$PR_DATA" | jq empty 2>/dev/null; then
    echo "error_json" > "$CACHE_FILE"
    return 1
  fi
  
  # Save to cache
  echo "$PR_DATA" > "$CACHE_FILE"
  return 0
}

calculate_counts() {
  if [ ! -f "$CACHE_FILE" ]; then
    FAIL_COUNT=0
    PASS_COUNT=0
    PENDING_COUNT=0
    return
  fi
  
  # Check for error states
  CACHE_CONTENT=$(cat "$CACHE_FILE")
  if [[ "$CACHE_CONTENT" == "error_"* ]] || [[ "$CACHE_CONTENT" == "no_wifi" ]]; then
    FAIL_COUNT=0
    PASS_COUNT=0
    PENDING_COUNT=0
    return
  fi
  
  # Count PRs by status
  FAIL_COUNT=$(echo "$CACHE_CONTENT" | jq '[.[] | select(.checks_status == "failing")] | length' 2>/dev/null || echo 0)
  PASS_COUNT=$(echo "$CACHE_CONTENT" | jq '[.[] | select(.checks_status == "passing" or .checks_status == "no_checks")] | length' 2>/dev/null || echo 0)
  PENDING_COUNT=$(echo "$CACHE_CONTENT" | jq '[.[] | select(.checks_status == "pending")] | length' 2>/dev/null || echo 0)
}

render_status_items() {
  # Set failed item
  if [ $FAIL_COUNT -gt 0 ]; then
    sketchybar --set github_prs.failed \
      icon=$ICON_PR_FAIL \
      icon.color=$(getcolor red) \
      label="$FAIL_COUNT" \
      drawing=on
  else
    sketchybar --set github_prs.failed drawing=off
  fi
  
  # Set passed item
  if [ $PASS_COUNT -gt 0 ]; then
    sketchybar --set github_prs.passed \
      icon=$ICON_PR_PASS \
      icon.color=$(getcolor green) \
      label="$PASS_COUNT" \
      drawing=on
  else
    sketchybar --set github_prs.passed drawing=off
  fi
  
  # Set pending item
  if [ $PENDING_COUNT -gt 0 ]; then
    sketchybar --set github_prs.pending \
      icon=$ICON_PR_PENDING \
      icon.color=$(getcolor yellow) \
      label="$PENDING_COUNT" \
      drawing=on
  else
    sketchybar --set github_prs.pending drawing=off
  fi
}

render_bar_item() {
  DRAWING=$([ "$(cat /tmp/sketchybar_sender 2>/dev/null)" == "focus_on" ] && echo "off" || echo "on")
  
  # Check for no WiFi
  if ! check_wifi; then
    sketchybar --set github_prs \
      icon=$ICON_WIFI_OFF \
      icon.color=$(getcolor red) \
      label="none" \
      label.drawing=on \
      drawing=$DRAWING
    # Hide status items
    sketchybar --set github_prs.failed drawing=off \
               --set github_prs.passed drawing=off \
               --set github_prs.pending drawing=off
    return
  fi
  
  # Check for error states
  if [ -f "$CACHE_FILE" ]; then
    CACHE_CONTENT=$(cat "$CACHE_FILE")
    if [[ "$CACHE_CONTENT" == "error_"* ]]; then
      sketchybar --set github_prs \
        icon=$ICON_GITHUB \
        icon.color=$ICON_COLOR \
        label="error" \
        label.color=$(getcolor red) \
        label.drawing=on \
        drawing=$DRAWING
      # Hide status items
      sketchybar --set github_prs.failed drawing=off \
                 --set github_prs.passed drawing=off \
                 --set github_prs.pending drawing=off
      return
    fi
  fi
  
  # Calculate counts
  calculate_counts
  
  # Check if all counts are zero
  TOTAL_COUNT=$((FAIL_COUNT + PASS_COUNT + PENDING_COUNT))
  
  # Render main GitHub icon
  if [ $TOTAL_COUNT -eq 0 ]; then
    sketchybar --set github_prs \
      icon=$ICON_GITHUB \
      icon.color=$ICON_COLOR \
      label="none" \
      label.drawing=on \
      drawing=$DRAWING
    # Hide status items
    sketchybar --set github_prs.failed drawing=off \
               --set github_prs.passed drawing=off \
               --set github_prs.pending drawing=off
  else
    sketchybar --set github_prs \
      icon=$ICON_GITHUB \
      icon.color=$ICON_COLOR \
      label.drawing=off \
      drawing=$DRAWING
    # Render status items
    render_status_items
  fi
}

render_popup() {
  if [ ! -f "$CACHE_FILE" ]; then
    return
  fi
  
  CACHE_CONTENT=$(cat "$CACHE_FILE")
  
  # Don't render PR items for error states
  if [[ "$CACHE_CONTENT" == "error_"* ]] || [[ "$CACHE_CONTENT" == "no_wifi" ]]; then
    return
  fi
  
  # Cleanup old items first
  cleanup_old_pr_items
  
  # Get PR count
  PR_COUNT=$(echo "$CACHE_CONTENT" | jq 'length' 2>/dev/null || echo 0)
  
  if [ $PR_COUNT -eq 0 ]; then
    return
  fi
  
  # Build array of sketchybar commands
  args=()
  
  # Iterate through PRs and create items
  for i in $(seq 0 $(($PR_COUNT - 1))); do
    PR=$(echo "$CACHE_CONTENT" | jq ".[$i]")
    
    PR_NUMBER=$(echo "$PR" | jq -r '.pr_number')
    BRANCH=$(echo "$PR" | jq -r '.branch')
    PR_URL=$(echo "$PR" | jq -r '.pr_url')
    CHECKS_STATUS=$(echo "$PR" | jq -r '.checks_status')
    SUCCESSFUL_CHECKS=$(echo "$PR" | jq -r '.successful_checks')
    TOTAL_CHECKS=$(echo "$PR" | jq -r '.total_checks')
    
    # Determine icon and color based on status
    case "$CHECKS_STATUS" in
      "failing")
        PR_ICON=$ICON_PR_FAIL
        PR_ICON_COLOR=$(getcolor red)
        ;;
      "passing"|"no_checks")
        PR_ICON=$ICON_PR_PASS
        PR_ICON_COLOR=$(getcolor green)
        ;;
      "pending")
        PR_ICON=$ICON_PR_PENDING
        PR_ICON_COLOR=$(getcolor yellow)
        ;;
      *)
        PR_ICON=$ICON_PR_PENDING
        PR_ICON_COLOR=$ICON_COLOR
        ;;
    esac
    
    # Build label
    PR_LABEL="${SUCCESSFUL_CHECKS}/${TOTAL_CHECKS} ${BRANCH}"
    
    # Add item to popup
    args+=(
      --add item "github_prs.pr_${PR_NUMBER}" popup.github_prs
      --set "github_prs.pr_${PR_NUMBER}"
        "${menu_item_defaults[@]}"
        icon="$PR_ICON"
        icon.color="$PR_ICON_COLOR"
        label="$PR_LABEL"
        click_script="open '${PR_URL}'; $POPUP_OFF"
    )
  done
  
  # Execute all commands at once
  if [ ${#args[@]} -gt 0 ]; then
    sketchybar "${args[@]}" >/dev/null
  fi
}

update() {
  # Reset update frequency if it was set to 1 for manual refresh
  sketchybar --set "$NAME" update_freq=600
  
  fetch_prs
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
"refresh")
  # Manual refresh triggered
  update
  ;;
esac
