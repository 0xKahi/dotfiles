# ================ Setup Gcloud SDK ===========================
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kahi/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kahi/Downloads/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/kahi/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kahi/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
# ================ Setup Gcloud SDK end ========================

# ================ Setup JoJo command ===========================
# Load custom JoJo scripts and commands and completions
[ -f "$HOME/Desktop/code/jojo/jojo-scripts/entrypoint.zsh" ] && source "$HOME/Desktop/code/jojo/jojo-scripts/entrypoint.zsh"
# ======================= end ====================================

# ================ Setup nvm completion ===========================
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
# ======================= end ====================================
