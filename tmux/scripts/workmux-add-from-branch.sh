#!/usr/bin/env bash
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Not a git repository"
  echo "Press any key to close."
  read -n 1 -s
  exit 1
fi

target_pane=$(tmux display-message -p '#{pane_id}')
selection=$(git branch --format='%(refname:short)' | fzf --popup 70%,25%)
[ -z "$selection" ] && exit 0

printf -v popup_command 'workmux add %q' "$selection"
printf -v popup_command '%s || { echo; echo %q; read -n 1 -s; }' \
  "$popup_command" 'workmux add failed. Press any key to close.'

tmux popup -d "$PWD" -e "TMUX_PANE=$target_pane" -w 70% -h 25% -E "$popup_command"
