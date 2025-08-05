# Agent Guidelines for Dotfiles Repository

## Build/Lint/Test Commands
- **Lua formatting**: `stylua .` (uses .stylua.toml config)
- **Setup symlinks**: `./scripts/symlinks.sh --create`
- **Remove symlinks**: `./scripts/symlinks.sh --delete`
- **Stow configs**: `stow .` (symlinks to ~/.config)

## Code Style Guidelines

### Lua (Neovim configs)
- 2 spaces indentation, 120 char line width
- Single quotes preferred, always use call parentheses
- Module pattern: `local M = {}` then `return M`
- Require statements at top: `local wezterm = require('wezterm')`
- Config tables use snake_case keys

### Shell Scripts
- Use `#!/bin/bash` shebang
- Source utility functions: `. $SCRIPT_DIR/utils.sh`
- Double quotes for variables: `"$variable"`
- Error handling with info/warning/error/success functions

### General Conventions
- Use descriptive variable names in snake_case
- Comment complex logic but avoid obvious comments
- Maintain consistent indentation and formatting
- Follow existing patterns in each config directory