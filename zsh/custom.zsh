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

# atuin setup place before fzf or ^r keybindings will be overwritten
eval "$(atuin init zsh)"

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

# Created by `pipx` on 2025-05-30 19:55:17
export PATH="/Users/kahi/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/kahi/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# initialize zoxide
eval "$(zoxide init zsh)"

# set up zsh syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

[ -f "$HOME/.config/zsh/configs/vi-mode.zsh" ] && source "$HOME/.config/zsh/configs/vi-mode.zsh"
