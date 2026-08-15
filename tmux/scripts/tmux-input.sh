#!/usr/bin/env bash
#
# tmux-input.sh — styled input popup for tmux
#
# Opens a small rounded popup, waits for one line of input (full readline
# editing, so your vi/emacs bindings from ~/.inputrc apply), then runs a
# command with the input appended as the last argument (also exported as
# $TMUX_INPUT).
#
# Usage:
#   tmux-input.sh [options] [-- command [args...]]
#
# Options:
#   -l, --label TEXT      label drawn on the popup border
#   -p, --prefix TEXT     prompt prefix inside the popup (default: )
#   -w, --width SPEC      popup width, cells or percent (default: 25%)
#   -h, --height SPEC     popup height, cells or percent (default: 3)
#       --help            show this help
#
# Examples:
#   tmux-input.sh -l Cmdline -- workmux add
#   tmux-input.sh --prefix "branch:" -- workmux add
#   tmux-input.sh -l "Rename Window" -- tmux rename-window
#
# When no command is given, the input is printed to stdout instead.

set -u

SELF="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/$(basename -- "${BASH_SOURCE[0]}")"

BORDER='#FFC777'                     # popup border + label colour

label=''
prefix=' '
width='30%'
height='3'

die() { printf 'tmux-input: %s\n' "$*" >&2; exit 1; }

usage() { grep '^#' "$0" | tail -n +2 | sed 's/^# \{0,1\}//'; }

# ---------------------------------------------------------------------------
# Inner mode: we are the process inside the popup — read input, run command.
# ---------------------------------------------------------------------------
if [[ ${TMUX_INPUT_INNER:-} == 1 ]]; then
  prefix_text="${TMUX_INPUT_PREFIX:- }"

  # \001/\002 mark non-printing sequences so readline counts columns correctly.
  prompt=$(printf '\001\033[94m\002%s\001\033[0m\002 ' "$prefix_text")

  # Readline's vi mode prompt redraw corrupts a terminal that is only one row high.
  # Vi keybindings remain enabled; only the insert/command mode prompt is disabled.
  bind 'set show-mode-in-prompt off' 2>/dev/null

  IFS= read -e -r -p "$prompt" input || exit 0 # Ctrl-C / Ctrl-D: just close
  [[ -z $input ]] && exit 0

  if [[ -n ${TMUX_INPUT_CMD:-} ]]; then
    eval "set -- $TMUX_INPUT_CMD"
    export TMUX_INPUT="$input"
    "$@" "$input" && exit 0

    status=$?
    printf '\n\033[38;2;239;143;164m✘ %s exited with %s — press any key to close\033[0m\n' "$1" "$status"
    read -r -n 1 -s
  else
    printf '%s\n' "$input"
  fi
  exit 0
fi

# ---------------------------------------------------------------------------
# Outer mode: parse flags and spawn the popup.
# ---------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    -l | --label) label="${2-}"; shift 2 ;;
    -p | --prefix) prefix="${2-}"; shift 2 ;;
    -w | --width) width="${2-}"; shift 2 ;;
    -h | --height) height="${2-}"; shift 2 ;;
    --help) usage; exit 0 ;;
    --) shift; break ;;
    -*) die "unknown option: $1 (see --help)" ;;
    *) break ;;
  esac
done

[[ -n ${TMUX:-} ]] || die 'not running inside tmux'
command -v tmux >/dev/null 2>&1 || die 'tmux not found'

q() { printf '%q' "$1"; }

popup_cmd="TMUX_INPUT_INNER=1"
popup_cmd+=" TMUX_INPUT_PREFIX=$(q "$prefix")"
popup_cmd+=" TMUX_INPUT_CMD=$(q "$(printf '%q ' "$@")")"
popup_cmd+=" $(q "$SELF")"

if [[ -n $label ]]; then
  escaped_label=${label//\#/##}
  title="#[fg=${BORDER},bold] ${escaped_label} #[fg=${BORDER}]"
else
  title=''
fi

tmux display-popup \
  -d '#{pane_current_path}' \
  -x C -y C \
  -w "$width" -h "$height" \
  -b rounded \
  -S "fg=${BORDER}" \
  -T "$title" \
  -E "$popup_cmd"

status=$?
[[ $status -eq 2 ]] && exit 0 # Ctrl-C or Escape dismissed the popup
exit "$status"
