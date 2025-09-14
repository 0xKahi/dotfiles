# tokyonight_cyberpunk fzf theme
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --height=25%\
  --ansi \
  --layout=reverse \
  --border \
  --color=bg:-1 \
  --color=bg+:#311b92 \
  --color=border:#00FF9C \
  --color=label:#ED7892 \
  --color=fg:#c8d3f5 \
  --color=gutter:#1e2030 \
  --color=header:#D498F8 \
  --color=hl+:#55BBF9 \
  --color=hl:#55BBF9 \
  --color=info:#545c7e \
  --color=marker:#fca7ea \
  --color=pointer:#fca7ea \
  --color=prompt:#ED7892 \
  --color=query:#c8d3f5:regular \
  --color=scrollbar:#55BBF9 \
  --color=separator:#FDF980 \
  --color=spinner:#ED7892 \
"

export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
