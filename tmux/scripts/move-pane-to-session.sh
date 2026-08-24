#!/bin/bash

set -u

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SELF="$SCRIPT_DIR/$(basename -- "${BASH_SOURCE[0]}")"
INPUT_SCRIPT="$SCRIPT_DIR/tmux-input.sh"

fail() {
  printf 'move-pane-to-session: %s\n' "$*" >&2
  return 1
}

move_pane() {
  local source_pane="$1"
  local session_name="$2"
  local create_session="$3"
  local window_name="$4"
  local placeholder_window=''

  if ! tmux display-message -p -t "$source_pane" '#{pane_id}' >/dev/null 2>&1; then
    fail 'source pane no longer exists'
    return 1
  fi

  if [[ $create_session == '1' ]]; then
    placeholder_window=$(tmux new-session -d -P -F '#{window_id}' -s "$session_name") || return 1
  elif ! tmux has-session -t "$session_name" 2>/dev/null; then
    fail "session no longer exists: $session_name"
    return 1
  fi

  if ! tmux break-pane -d -n "$window_name" -s "$source_pane" -t "$session_name:"; then
    if [[ -n $placeholder_window ]]; then
      tmux kill-session -t "$session_name" 2>/dev/null
    fi
    return 1
  fi

  if [[ -n $placeholder_window ]]; then
    tmux kill-window -t "$placeholder_window"
  fi
}

if [[ ${1-} == '--move' ]]; then
  if [[ $# -ne 5 ]]; then
    fail 'missing source pane, session, creation mode, or window name'
    exit 1
  fi

  move_pane "$2" "$3" "$4" "$5"
  exit $?
fi

[[ -n ${TMUX:-} ]] || { fail 'not running inside tmux'; exit 1; }
command -v fzf >/dev/null 2>&1 || { fail 'fzf not found'; exit 1; }
[[ -x $INPUT_SCRIPT ]] || { fail "$INPUT_SCRIPT is not executable"; exit 1; }

source_pane=$(tmux display-message -p '#{pane_id}') || exit 1
fzf_output=$(
  tmux list-sessions -F '#{session_name}' |
    fzf --popup=45%,40% \
      --print-query \
      --bind='enter:accept' \
      --prompt='session> ' \
      --header='Select a session or type a new name' \
      --border-label=' Move pane '
)
fzf_status=$?

# fzf exits with 1 when the query has no match, even though --print-query
# returns the new session name. Only treat cancellation or an empty query as aborting.
[[ $fzf_status -eq 0 || $fzf_status -eq 1 ]] || exit 0
[[ -n $fzf_output ]] || exit 0

query=${fzf_output%%$'\n'*}
selection=''
if [[ $fzf_output == *$'\n'* ]]; then
  selection=${fzf_output#*$'\n'}
fi

if [[ -n $query && $query != "$selection" ]]; then
  target_session="$query"
  if tmux has-session -t "=$target_session" 2>/dev/null; then
    create_session='0'
  else
    create_session='1'
  fi
elif [[ -n $selection ]]; then
  target_session="$selection"
  create_session='0'
else
  exit 0
fi

"$INPUT_SCRIPT" -l 'window name' -- "$SELF" --move "$source_pane" "$target_session" "$create_session"
