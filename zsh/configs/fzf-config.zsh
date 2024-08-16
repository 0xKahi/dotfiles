# tokyonight_cyberpunk fzf theme
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border \
  --color=bg:-1 \
  --color=bg+:#311b92 \
  --color=border:#00FF9C \
  --color=fg:#c8d3f5 \
  --color=gutter:#1e2030 \
  --color=header:#ff966c \
  --color=hl+:#65bcff \
  --color=hl:#65bcff \
  --color=info:#545c7e \
  --color=marker:#EF8FA4 \
  --color=pointer:#EF8FA4 \
  --color=prompt:#DDAFF8 \
  --color=query:#c8d3f5:regular \
  --color=scrollbar:#589ed7 \
  --color=separator:#00FF9C \
  --color=spinner:#EF8FA4 \
"

export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
