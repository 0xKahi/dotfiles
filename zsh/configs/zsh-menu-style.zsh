# reference: https://zsh.sourceforge.io/Guide/zshguide06.html
ZLS_COLORS="no=00:fi=00:di=01;34:ln=01;36:\
pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:\
or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:\
*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:\
*.z=01;31:*.Z=01;31:*.gz=01;31:*.deb=01;31:\
*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:\
*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:\
*.mpg=01;37:*.avi=01;37:*.gl=01;37:*.dl=01;37:\
lc=\e[:rm=m:tc=00:sp=00:ma=07:hi=01;33:du=00"

# Load complist module to enable menuselect keymap
zmodload zsh/complist

# Vi keybindings for menu selection
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Enable menu selection (use arrow keys to navigate completions)
zstyle ':completion:*' group-name ''

# Format for completion groups and descriptions
zstyle ':completion:*:descriptions' format '%F{cyan}-- %d --%f'
zstyle ':completion:*:messages' format '%F{magenta}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*:corrections' format '%F{yellow}-- %d (errors: %e) --%f'

# Generic alternating colors based on first letter (rainbow effect)
zstyle ':completion:*' list-colors \
  '=(#b)([a-c]*)( #-- *)=0=32=1;37' \
  '=(#b)([d-f]*)( #-- *)=0=36=1;37' \
  '=(#b)([g-m]*)( #-- *)=0=35=1;37' \
  '=(#b)([n-r]*)( #-- *)=0=33=1;37' \
  '=(#b)([s-z]*)( #-- *)=0=34=1;37' \
  ${(s.:.)ZLS_COLORS}

# Highlight the selected item 
zstyle ':completion:*' menu select=long-list
