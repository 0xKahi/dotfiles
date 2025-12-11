# for profiling zsh startup
# zmodload zsh/zprof

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY
setopt extended_glob
setopt prompt_subst # prompt substitution

[ -f "$HOME/.config/zsh/custom.zsh" ] && source "$HOME/.config/zsh/custom.zsh"

[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"

[ -f "$HOME/.config/zsh/external.zsh" ] && source "$HOME/.config/zsh/external.zsh"

[ -f "$HOME/.config/zsh/secrets.zsh" ] && source "$HOME/.config/zsh/secrets.zsh"

[ -f "$HOME/.config/zsh/startup.zsh" ] && source "$HOME/.config/zsh/startup.zsh"

# for profiling zsh startup
# zprof
