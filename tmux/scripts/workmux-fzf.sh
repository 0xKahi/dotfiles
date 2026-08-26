#!/usr/bin/env bash

set -o pipefail

cmd=''
filter_spec=''
workmux_args=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    --filter)
      [ "$#" -lt 2 ] && { echo 'workmux-fzf: --filter requires a value' >&2; exit 1; }
      filter_spec="$2"
      shift 2
      ;;
    --filter=*)
      filter_spec="${1#*=}"
      shift
      ;;
    *)
      if [ -z "$cmd" ]; then
        cmd="$1"
      else
        workmux_args+=("$1")
      fi
      shift
      ;;
  esac
done

[ -z "$cmd" ] && { echo 'usage: workmux-fzf.sh COMMAND [ARGS...] [--filter key=value,...]' >&2; exit 1; }

filters='{}'
if [ -n "$filter_spec" ]; then
  if ! filters=$(jq -Rn --arg spec "$filter_spec" '
    def boolean:
      if . == "true" then true
      elif . == "false" then false
      else error("filter values must be true or false")
      end;

    $spec
    | split(",")
    | map(split("=") as $parts
        | if ($parts | length) != 2 then error("filters must use key=value") else $parts end
        | if .[0] | IN("is_main", "is_open", "has_uncommitted_changes")
          then { key: .[0], value: (.[1] | boolean) }
          else error("unsupported filter: \(.[0])")
          end)
    | from_entries
  ' 2>/dev/null); then
    echo "workmux-fzf: invalid filter: $filter_spec" >&2
    exit 1
  fi
fi

if ! choices=$(workmux list --json | jq -r --argjson filters "$filters" '
  def age:
    if .is_main then "-"
    else (now - (.created_at // now)) as $seconds
      | if $seconds < 60 then "now"
        elif $seconds < 3600 then "\(($seconds / 60) | floor)m"
        elif $seconds < 86400 then "\(($seconds / 3600) | floor)h"
        elif $seconds < 604800 then "\(($seconds / 86400) | floor)d"
        elif $seconds < 2592000 then "\(($seconds / 604800) | floor)w"
        elif $seconds < 31536000 then "\(($seconds / 2592000) | floor)mo"
        else "\(($seconds / 31536000) | floor)y"
        end
    end;
  def pad($width): . + (" " * ($width - length));

  map(select(. as $item | all($filters | to_entries[]; $item[.key] == .value)))
  | map(. + {
      branch_label: (.branch + if .is_main then " (here)" else "" end),
      age_label: age
    })
  | (map(.branch_label | length) | max // 0) as $branch_width
  | (map(.handle | length) | max // 0) as $handle_width
  | .[]
  | . as $item
  | [
      .branch,
      ((if .has_uncommitted_changes then "" else "" end)
       + " " + (.branch_label | pad($branch_width))
       + "  " + (if .is_open then " " else " " end)
       + "  " + (.handle | pad($handle_width))
       + "  (" + .age_label + ")")
    ]
  | @tsv
'); then
  echo 'workmux-fzf: failed to list worktrees' >&2
  exit 1
fi

[ -z "$choices" ] && exit 0

target_pane=$(tmux display-message -p '#{pane_id}')
selection=$(printf '%s\n' "$choices" | fzf --popup 70%,25% --delimiter=$'\t' --with-nth=2 --prompt='worktree> ')
[ -z "$selection" ] && exit 0

IFS=$'\t' read -r branch _ <<< "$selection"
args=("$cmd" "$branch" "${workmux_args[@]}")

printf -v quoted_args ' %q' "${args[@]}"
popup_command="workmux$quoted_args"
printf -v error_message 'workmux %s failed. Press any key to close.' "${args[*]}"
printf -v popup_command '%s || { echo; echo %q; read -n 1 -s; }' "$popup_command" "$error_message"

tmux popup -d "$PWD" -e "TMUX_PANE=$target_pane" -w 70% -h 25% -E "$popup_command"
