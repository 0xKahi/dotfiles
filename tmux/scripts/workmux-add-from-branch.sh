#!/usr/bin/env bash

# Works in tmux (fzf and workmux open in tmux popups) and outside it, e.g. in a
# Rex floating pane, where fzf and workmux run in the current pane instead.
in_tmux() { [ -n "${TMUX:-}" ]; }

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Not a git repository"
  echo "Press any key to close."
  read -n 1 -s
  exit 1
fi

fzf_args=(--popup 20%,25% --prompt="branch> ")
# --popup is ignored outside tmux, so fill our own pane instead of FZF_DEFAULT_OPTS' --height
in_tmux || fzf_args+=(--height=100%)
selection=$(git branch --format='%(refname:short)' | fzf "${fzf_args[@]}")
[ -z "$selection" ] && exit 0

printf -v popup_command 'workmux add %q' "$selection"
printf -v popup_command '%s || { echo; echo %q; read -n 1 -s; }' \
  "$popup_command" 'workmux add failed. Press any key to close.'

if in_tmux; then
  target_pane=$(tmux display-message -p '#{pane_id}')
  tmux popup -d "$PWD" -e "TMUX_PANE=$target_pane" -w 70% -h 25% -E "$popup_command"
else
  exec bash -c "$popup_command"
fi
