#!/bin/bash
# Move the current pane to another session.
#   1. pick a session, or type a new name to create one (pane goes into window "0")
#   2. for an existing session, pick a window (pane joins it as a floating pane)
#      or type a new name to create a window

set -u

fail() {
  tmux display-message "move-pane-to-session: $*"
  return 1
}

# Enter copies the highlighted match into the query, then prints the query.
# Picking a filtered item returns that item; typing a name with no match returns the typed text.
pick() {
  local label="$1" prompt="$2"
  fzf --popup=45%,40% \
    --bind='enter:replace-query+print-query' \
    --pointer='▶' \
    --prompt="$prompt> " \
    --header='Select an entry or type a new name' \
    --border-label=" $label "
}

[[ -n ${TMUX:-} ]] || { echo 'move-pane-to-session: not running inside tmux' >&2; exit 1; }
command -v fzf >/dev/null 2>&1 || { fail 'fzf not found'; exit 1; }

source_pane=$(tmux display-message -p '#{pane_id}') || exit 1
source_window=$(tmux display-message -p -t "$source_pane" '#{window_id}') || exit 1

session=$(tmux list-sessions -F '#{session_name}' | pick 'Move pane' 'session') || exit 0
[[ -n $session ]] || exit 0

if ! tmux has-session -t "=$session" 2>/dev/null; then
  placeholder_window=$(tmux new-session -d -P -F '#{window_id}' -s "$session") || exit 1
  if ! tmux break-pane -d -n '0' -s "$source_pane" -t "=$session:"; then
    tmux kill-session -t "=$session" 2>/dev/null
    exit 1
  fi
  tmux kill-window -t "$placeholder_window"
  exit 0
fi

windows=$(tmux list-windows -t "=$session" -F '#{window_name}:#{window_index}') || exit 1
window=$(printf '%s\n' "$windows" | pick "Move pane to $session" 'window') || exit 0
[[ -n $window ]] || exit 0

if grep -Fxq -- "$window" <<<"$windows"; then
  target="=$session:${window##*:}"
  target_window=$(tmux display-message -p -t "$target" '#{window_id}') || exit 1
  if [[ $target_window == "$source_window" ]]; then
    fail 'pane is already in that window'
    exit 0
  fi
  tmux join-pane -d -s "$source_pane" -t "$target" && tmux break-pane -W -d -s "$source_pane"
else
  tmux break-pane -d -n "$window" -s "$source_pane" -t "=$session:"
fi
