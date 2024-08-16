# Path to your oh-my-zsh installation.
#export ZSH="$HOME/.oh-my-zsh"

### for HOMEBREW arm64 && x86_64
# export PATH="/opt/homebrew/bin:$HOME/bin:/usr/local/bin:$PATH"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
# auto completion
setopt prompt_subst # prompt subsitution
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case-insensitive completion
## auto completion for bash in zsh
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit

#source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

export LANG="en_US.UTF-8" # Sets default locale for all categories
export LC_ALL="en_US.UTF-8" # Overrides all other locale settings
export LC_CTYPE="en_US.UTF-8" # Controls character classification and case conversion

export EDITOR=/opt/homebrew/bin/nvim

# FZF stuff
eval "$(fzf --zsh)"

# --- setup fzf theme ---
# import theme from script
[ -f "$HOME/.config/zsh/scripts/tky-cyberpunk-fzf-theme.zsh" ] && source "$HOME/.config/zsh/scripts/tky-cyberpunk-fzf-theme.zsh"
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# tree stuff
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"

# lazy
alias lg="lazygit --use-config-file="$HOME/.config/lazygit/lazygit-config.yml""
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
# bindkey '^y' autosuggest-accept
# bindkey '^u' autosuggest-toggle
# bindkey '^k' up-line-or-search
# bindkey '^j' down-line-or-search

# setup vim in terminal 
## source ~/.config/zsh/scripts/vi-mode.zsh
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
