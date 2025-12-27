# Brew Setup

This directory contains Homebrew package lists for easy migration between machines.

## File Structure

- **leaves.txt** - Command-line tools and packages with full tap paths (e.g., `felixkratz/formulae/borders`)
- **casks.txt** - GUI applications with full tap paths (e.g., `nikitabobko/tap/aerospace`)

## Backup Current Setup

Run these commands to save your current Homebrew installation:

```sh
brew leaves > brew/leaves.txt
brew list --cask --full-name > brew/casks.txt
```

## Restore on New Machine

Install all packages (Homebrew will auto-tap third-party repositories as needed):

```sh
# Install formulae (auto-taps third-party repos like felixkratz/formulae)
xargs brew install < brew/leaves.txt

# Install casks (auto-taps third-party repos like nikitabobko/tap)
xargs brew install --cask < brew/casks.txt
```

### One-Line Restore Command

```sh
xargs brew install < brew/leaves.txt && xargs brew install --cask < brew/casks.txt
```

## How It Works

- **Auto-tapping**: When you install a formula or cask using full tap notation (e.g., `brew install felixkratz/formulae/borders`), Homebrew automatically taps the repository if it's not already tapped
- **leaves.txt**: Uses `brew leaves` to track only top-level packages (not dependencies). Packages from custom taps include the full path (e.g., `felixkratz/formulae/borders`)
- **casks.txt**: Uses `brew list --cask --full-name` to preserve tap information (e.g., `nikitabobko/tap/aerospace`)
- **No manual tapping required**: The full tap notation in both files ensures Homebrew handles tapping automatically during installation

## Examples

When restoring, Homebrew will automatically handle taps:

```sh
# These commands auto-tap if needed:
brew install felixkratz/formulae/borders      # Auto-taps felixkratz/formulae
brew install hashicorp/tap/terraform          # Auto-taps hashicorp/tap
brew install --cask nikitabobko/tap/aerospace # Auto-taps nikitabobko/tap
```

