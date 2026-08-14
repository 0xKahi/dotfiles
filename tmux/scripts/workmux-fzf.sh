#!/usr/bin/env bash
cmd="$1"
flag="$2"
[ -z "$cmd" ] && exit 1

target_pane=$(tmux display-message -p '#{pane_id}')
selection=$(workmux list | tail -n +2 | fzf --popup 70%,25%)
[ -z "$selection" ] && exit 0

branch=$(echo "$selection" | awk '{print $1}')
args=("$cmd" "$branch")
[ -n "$flag" ] && args+=("$flag")

printf -v quoted_args ' %q' "${args[@]}"
popup_command="workmux$quoted_args"
printf -v error_message 'workmux %s failed. Press any key to close.' "${args[*]}"
printf -v popup_command '%s || { echo; echo %q; read -n 1 -s; }' "$popup_command" "$error_message"

tmux popup -d "$PWD" -e "TMUX_PANE=$target_pane" -w 70% -h 25% -E "$popup_command"
