#!/bin/bash

MENU_TITLE="Sessions"

# Build the menu items array
index=1
sessions=()
while IFS=: read -r session attached; do
    [[ "$attached" == "1" ]] && continue

    sessions+=("$session" "$index" "switch-client -t $session")
    ((index++))
done < <(tmux list-sessions -F '#{session_name}:#{session_attached}')

# Execute the menu
tmux display-menu -T "$MENU_TITLE" "${sessions[@]}"
