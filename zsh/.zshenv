# Locale settings
export LANG="en_US.UTF-8" # Sets default locale for all categories
export LC_ALL="en_US.UTF-8" # Overrides all other locale settings
export LC_CTYPE="en_US.UTF-8" # Controls character classification and case conversion

# Editor configuration
export EDITOR='/opt/homebrew/bin/nvim'
export VISUAL="$EDITOR"

# Cargo environment
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Tool configuration paths
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export ATAC_KEY_BINDINGS=~/.config/atac/keybindings.toml
export ATAC_THEME=~/.config/atac/theme.toml
export LG_CONFIG_FILE="$HOME/.config/lazygit/lazygit-config.yml"

# PATH additions
# pipx
# Created by `pipx` on 2025-05-30 19:55:17
export PATH="/Users/kahi/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/kahi/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export PATH="/Users/kahi/.bun/bin:$PATH"

# conda (fallback PATH only - full init in .zprofile)
# if [ -f "/Users/kahi/miniforge3/bin/conda" ]; then
#   export PATH="/Users/kahi/miniforge3/bin:$PATH"
# fi

