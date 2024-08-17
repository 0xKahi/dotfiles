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
  --color=header:#FDF980 \
  --color=hl+:#55BBF9 \
  --color=hl:#55BBF9 \
  --color=info:#545c7e \
  --color=marker:#ED7892 \
  --color=pointer:#ED7892 \
  --color=prompt:#D498F8 \
  --color=query:#c8d3f5:regular \
  --color=scrollbar:#55BBF9 \
  --color=separator:#00FF9C \
  --color=spinner:#ED7892 \
"

export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
