#!/bin/bash
# Resize the active floating pane's height while keeping its top border fixed.
#   minimize: shrink from the bottom up to MIN_HEIGHT lines (incl. borders)
#   expand:   grow from the bottom down, leaving BOTTOM_GAP lines below the pane

set -u

MIN_HEIGHT=4
BOTTOM_GAP=1 # matches the gap tmux leaves when fitting a split floating pane

pane="${2:-$(tmux display -p '#{pane_id}')}"
read -r floating pane_top window_height < <(tmux display -t "$pane" -p '#{pane_floating_flag} #{pane_top} #{window_height}')

[ "$floating" = "1" ] || exit 0

case "${1:-}" in
  minimize)
    tmux resize-pane -t "$pane" -y "$MIN_HEIGHT"
    ;;
  expand)
    # top border sits at pane_top - 1; -y includes both borders
    tmux resize-pane -t "$pane" -y "$((window_height - (pane_top - 1) - BOTTOM_GAP))"
    ;;
  *)
    printf 'usage: float-height.sh minimize|expand [pane]\n' >&2
    exit 1
    ;;
esac
