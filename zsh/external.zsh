# ================ Setup Gcloud SDK ===========================
# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/apps/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/apps/google-cloud-sdk/path.zsh.inc"; fi
# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Downloads/apps/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/apps/google-cloud-sdk/completion.zsh.inc"; fi
# ================ Setup Gcloud SDK end ========================

# ================ Setup JoJo command ===========================
# Load custom JoJo scripts and commands and completions
[ -f "$HOME/Desktop/code/jojo/jojo-scripts/entrypoint.zsh" ] && source "$HOME/Desktop/code/jojo/jojo-scripts/entrypoint.zsh"
# ======================= end ====================================

# ================ Setup nvm completion ===========================
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
# ======================= end ====================================

# ================ Setup pnpm completion ===========================
[ -s "$HOME/.config/pnpm/completion-for-pnpm.zsh" ] && \. "$HOME/.config/pnpm/completion-for-pnpm.zsh"  # This loads pnpm bash_completion
# ======================= end ====================================

# ================ Setup pnpm completion g-plane ===========================
[ -s "$HOME/Desktop/code/editor_extras/zsh_plugins/pnpm-shell-completion_aarch64-apple-darwin/pnpm-shell-completion.plugin.zsh" ] && \. "$HOME/Desktop/code/editor_extras/zsh_plugins/pnpm-shell-completion_aarch64-apple-darwin/pnpm-shell-completion.plugin.zsh"
# ======================= end ====================================
