# Locale settings
export LANG="en_US.UTF-8" # Sets default locale for all categories
export LC_ALL="en_US.UTF-8" # Overrides all other locale settings
export LC_CTYPE="en_US.UTF-8" # Controls character classification and case conversion

export XDG_CONFIG_HOME="$HOME/.config" 

export EDITOR='nvim'
export VISUAL="$EDITOR"

# Cargo environment
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Tool configuration paths
export NVM_DIR="$HOME/.nvm"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export ATAC_KEY_BINDINGS=~/.config/atac/keybindings.toml
export ATAC_THEME=~/.config/atac/theme.toml
export LG_CONFIG_FILE="$XDG_CONFIG_HOME/lazygit/lazygit-config.yml"
export PI_CODING_AGENT_DIR="$XDG_CONFIG_HOME/pi/agent"
# export PI_CODING_AGENT_SESSION_DIR="$HOME/.pi/agent/sessions"

# PATH additions
# pipx
# Created by `pipx` on 2025-05-30 19:55:17
# used by uv as well
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

## custom python venv executables
export UVENV="$HOME/.uv-venv"
export UV_PYTHON="$UVENV/main/bin/python"
