# Path to your oh-my-zsh installation.
#export ZSH="$HOME/.oh-my-zsh"

### for HOMEBREW arm64 && x86_64
# export PATH="/opt/homebrew/bin:$HOME/bin:/usr/local/bin:$PATH"

# auto completion
setopt prompt_subst # prompt subsitution
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case-insensitive completion
## auto completion for bash in zsh
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# bindkey '^y' autosuggest-accept
# bindkey '^u' autosuggest-toggle


#source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

export EDITOR=/opt/homebrew/bin/nvim

source <(fzf --zsh)

# tree stuff
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"

# lazy
alias lg="lazygit"
alias ldg="lazydocker"

# vim
alias nvim="/opt/homebrew/bin/nvim"

# git
alias gcom="git commit -m"

# frequent access
alias code_file="z ~/Desktop/code"
alias obs_file="z ~/Desktop/code/obsidian"
alias SHUFFLE="z ~/Desktop/code/shuffle"
alias J2="z ~/Desktop/code/J2"

# for configs 
alias MYZSHRC="nvim ~/.config/zsh/.zshrc"
alias MYZSHENV="nvim ~/.zshenv"
alias MYZSHPROFILE="nvim ~/.zprofile"

# for brew x86_64
alias brew86="arch -x86_64 /usr/local/bin/brew"

# vim in terminal
source ~/.config/zsh/scripts/vi-mode.zsh
bindkey kj vi-cmd-mode

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

eval "$(zoxide init zsh)"
