# ============================================
# .zprofile - Login shell initialization
# Runs once when you log in
# ============================================

# Homebrew environment setup
# Sets HOMEBREW_* variables and adds /opt/homebrew/bin to PATH
# has to be in .zprofile or wrong brew will be used `/usr/local/bin/brew` instead of `/opt/homebrew/bin/brew`
# Fix when have time
eval "$(/opt/homebrew/bin/brew shellenv)"

# ================ Setup Conda ========================
## conda initialization
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

## Mamba initialization
if [ -f "/Users/kahi/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/Users/kahi/miniforge3/etc/profile.d/mamba.sh"
fi
# ================ Setup Conda end  ========================

# ================ Setup Gcloud SDK ====-=-====================
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kahi/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kahi/Downloads/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/kahi/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kahi/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
# ================ Setup Gcloud SDK end ========================

