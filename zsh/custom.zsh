# auto completion
setopt prompt_subst # prompt substitution
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case-insensitive completion

## auto completion
fpath=(${HOME}/.docker/completions $fpath) # for docker completions
autoload bashcompinit && bashcompinit # for bash in zsh
autoload -Uz compinit

# Only regenerate compdump (.zcompdump) once per hour (speeds up shell startup)
# if the file exists and is < 1hr old run (fast mode) etc compinit -C, else run full compinit
if [[ -n ~/.zcompdump(#qN.mh-1) ]]; then
  compinit -C # skips compdump and compaudit
  # compinit -i # skips compdump only 
  # compinit # skips none use this when you want to regenerate .zcompdump
else
  compinit
  printf "\e[105;30mDEBUG\e[0m .zcompdump regenerated \e[33m[%s]\e[0m\n" "$(date '+%H:%M:%S')"
fi

# Load hook management utility (used by lazy loading functions below)
# Use hook-based lazy loading (with add-zsh-hook) for tools that:
#   - Need to be ready before user interaction (like Ctrl+R keybindings)
#   - Don't have explicit commands users type (background integrations)
# Use shell wrapper lazy loading (function placeholders) for tools that:
#   - Are triggered by explicit commands (like 'z', 'zi', 'zoxide')
#   - Only needed when user specifically invokes them
autoload -Uz add-zsh-hook

#source $ZSH/oh-my-zsh.sh

# load starship prompt
eval "$(starship init zsh)"

# load fzf
eval "$(fzf --zsh)"
# load fzf theme and keybindings
[ -f "$HOME/.config/zsh/configs/fzf-config.zsh" ] && source "$HOME/.config/zsh/configs/fzf-config.zsh"


# ================ Lazy load atuin ========================
# - defers initialization until before first prompt
# - This improves shell startup time by ~30-80ms
# - Atuin provides enhanced shell history with Ctrl+R integration
_lazy_atuin() {
  unfunction _lazy_atuin 2>/dev/null  # Remove this helper function after first run
  eval "$(atuin init zsh)"            # Initialize atuin (history, keybindings, etc.)
}

# Register the lazy loader to run before the first prompt appears
add-zsh-hook precmd _lazy_atuin
# ====================== end ===============================

# ================ Lazy load zoxide ========================
# - defers initialization until first use of z/zi/zoxide commands
# - This improves shell startup time by ~10-30ms
zoxide() {
  unfunction z zi zoxide 2>/dev/null  # Remove placeholder functions
  eval "$(command zoxide init zsh)"   # Initialize zoxide (using 'command' to call real binary)
  zoxide "$@"                         # Execute the real zoxide command
}

z() {
  unfunction z zi zoxide 2>/dev/null  # Remove placeholder functions (silencing errors if already removed)
  eval "$(zoxide init zsh)"           # Initialize zoxide and create real z/zi functions
  z "$@"                              # Execute the real z command with original arguments
}

zi() {
  unfunction z zi zoxide 2>/dev/null  # Remove placeholder functions
  eval "$(zoxide init zsh)"           # Initialize zoxide
  zi "$@"                             # Execute the real zi command (interactive picker)
}
# ====================== end ===============================

# ================ yazi shell wrapper ======================
# yz: shell wrapper for yazi that allows changing directory if needed
# - `q`: to quit yazi and change directory
# - `Q`: to quit yazi without changing directory
function yz() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}
# ====================== end ===============================

# zsh menu style
[ -f "$HOME/.config/zsh/configs/zsh-menu-style.zsh" ] && source "$HOME/.config/zsh/configs/zsh-menu-style.zsh"

# set up zsh syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh


# enable vi mode
[ -f "$HOME/.config/zsh/configs/vi-mode.zsh" ] && source "$HOME/.config/zsh/configs/vi-mode.zsh"
