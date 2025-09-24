# Dotfiles

## Setup:

this setup uses stow and a custom symlink script from [hedrikmi]("https://github.com/hendrikmi/dotfiles/tree/main") to symlink files to the correct locations.

- stow is used to symlink the needed folders in dotfile directory to the `~/.config` directory for easier management of config files
- and the symlink script is mainly used to symlink files like `.zshrc` to specified directories that are needed to be else where defined in [symlinks_config.cof](./symlinks_config.conf)

### use stow to symlink all config files to `~/.config` directories

```bash
stow .
```

### symlinks script

this script is mainly for symlinking `.zshrc`/`.zshenv` config files in [symlink conf](./symlinks_config.conf)
stow only symlinks files to `~/.config` but zsh config is required in the home directory

#### Install

```bash
chmod +x ./scripts/symlinks.sh
./scripts/symlinks.sh --create
```

#### Unlink

```bash
./scripts/symlinks.sh --delete
```

### tmux catpuccin (manual installation)
- tpm version is not working properly

```bash
git clone -b v1.0.1 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
```
