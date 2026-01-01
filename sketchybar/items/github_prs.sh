#!/bin/bash

POPUP_OFF="sketchybar --set github_prs popup.drawing=off"

github_prs_failed=(
  "${item_defaults[@]}"
  icon="$ICON_PR_FAIL"
  icon.color="$(getcolor red)"
  icon.padding_right=5
  icon.padding_left=0
  label.padding_right=3
  label.drawing=on
  drawing=off
  updates=off
)

github_prs_passed=(
  "${item_defaults[@]}"
  icon="$ICON_PR_PASS"
  icon.color="$(getcolor green)"
  icon.padding_right=3
  icon.padding_left=0
  label.padding_right=3
  label.drawing=on
  drawing=off
  updates=off
)

github_prs_pending=(
  "${item_defaults[@]}"
  icon="$ICON_PR_PENDING"
  icon.color="$(getcolor yellow)"
  icon.padding_right=5
  icon.padding_left=0
  label.padding_right=3
  label.drawing=on
  drawing=off
  updates=off
)

github_prs=(
  "${menu_defaults[@]}"
  icon="$ICON_GITHUB"
  icon.padding_left=3
  label.drawing=off
  popup.align=left
  update_freq=600
  updates=on
  script="/Users/kahi/dotfiles/sketchybar/plugins/github_prs.sh"
  --subscribe github_prs mouse.clicked
                         mouse.exited
                         mouse.exited.global
)

github_prs_bracket=(
  "${bracket_defaults[@]}"
)

github_prs_refresh=(
  "${menu_item_defaults[@]}"
  icon="$ICON_REFRESH"
  label="Refresh PRs"
  click_script="rm /tmp/sketchybar_github_prs.json 2>/dev/null; sketchybar --set github_prs label=...; sketchybar --update --trigger github_prs; $POPUP_OFF"
  "${separator[@]}"
)

sketchybar \
  --add item github_prs.failed $1 \
  --set github_prs.failed "${github_prs_failed[@]}" \
  \
  --add item github_prs.passed $1 \
  --set github_prs.passed "${github_prs_passed[@]}" \
  \
  --add item github_prs.pending $1 \
  --set github_prs.pending "${github_prs_pending[@]}" \
  \
  --add item github_prs $1 \
  --set github_prs "${github_prs[@]}" \
  \
  --add bracket github_prs_bracket \
    github_prs.failed \
    github_prs.passed \
    github_prs.pending \
    github_prs \
  --set github_prs_bracket "${github_prs_bracket[@]}" \
  \
  --add item github_prs.refresh popup.github_prs \
  --set github_prs.refresh "${github_prs_refresh[@]}"
