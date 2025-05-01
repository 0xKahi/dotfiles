# auto completion
setopt prompt_subst # prompt subsitution
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case-insensitive completion
## auto completion for bash in zsh
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(${HOME}/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

#source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# ATAC stuff
export ATAC_KEY_BINDINGS=~/.config/atac/keybindings.toml
export ATAC_THEME=~/.config/atac/theme.toml

# lazygit stuff
export LG_CONFIG_FILE="$HOME/.config/lazygit/lazygit-config.yml"

# FZF stuff
eval "$(fzf --zsh)"
# --- setup fzf config ---
[ -f "$HOME/.config/zsh/configs/fzf-config.zsh" ] && source "$HOME/.config/zsh/configs/fzf-config.zsh"

# conda setup
__conda_setup="$('/Users/kahi/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/kahi/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/kahi/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/kahi/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/Users/kahi/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/Users/kahi/miniforge3/etc/profile.d/mamba.sh"
fi

# initialize zoxide
eval "$(zoxide init zsh)"

# set up zsh syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey -v
bindkey -M viins 'kj' vi-cmd-mode
export KEYTIMEOUT=10 # Makes switching modes quicker (should set to 1 but idk why my mac is slow)
export VI_MODE_SET_CURSOR=true 

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]]; then
    echo -ne '\e[1 q' # block
  else
    echo -ne '\e[5 q' # beam
  fi
}

zle -N zle-keymap-select

zle-line-init() {
  zle -K viins # initiate 'vi insert' as keymap (can be removed if 'binkey -V has been set elsewhere')
  echo -ne '\e[5 q'
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup


# Yank to the system clipboard
function vi-yank-xclip {
  zle vi-yank
  echo "$CUTBUFFER" | pbcopy -i
}

zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip
