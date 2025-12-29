#!/bin/bash

POPUP_OFF="sketchybar --set github_prs popup.drawing=off"

sketchybar --add item github_prs $1                  \
  --set github_prs                                        \
    "${menu_defaults[@]}"                                 \
    icon="$ICON_GITHUB"                                   \
    icon.padding_right=6                                  \
    label.drawing=on                                      \
    popup.align=right                                     \
    update_freq=600                                       \
    updates=on                                            \
    script="/Users/kahi/dotfiles/sketchybar/plugins/github_prs.sh" \
  --subscribe github_prs mouse.clicked                    \
                         mouse.exited                     \
                         mouse.exited.global              \
  --add item github_prs.refresh popup.github_prs          \
  --set github_prs.refresh                                \
    "${menu_item_defaults[@]}"                            \
    icon="$ICON_REFRESH"                                  \
    label="Refresh PRs"                                   \
    click_script="rm /tmp/sketchybar_github_prs.json 2>/dev/null; sketchybar --set github_prs label=...; sketchybar --update --trigger github_prs; $POPUP_OFF" \
    "${separator[@]}"
