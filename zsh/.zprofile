# ============================================
# .zprofile - Login shell initialization
# Runs once when you log in
# ============================================

# Homebrew environment setup
# Sets HOMEBREW_* variables and adds /opt/homebrew/bin to PATH
# has to be in .zprofile or wrong brew will be used `/usr/local/bin/brew` instead of `/opt/homebrew/bin/brew`
# Fix when have time
[ -x "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# ================ Setup Miniforge ========================
# Conda/Mamba initialization (both available with miniforge)
[ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ] && . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
# ================ Setup Miniforge end  ========================

# ================ Setup nvm ========================
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# ================ Setup end ========================

# Added by swiftly
[ -s "$HOME/.swiftly/env.sh" ] && \. "$HOME/.swiftly/env.sh"  # This loads swiftly 
