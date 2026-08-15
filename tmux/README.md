# TMUX setup


### tmux catpuccin (manual installation)
- using specific tag to avoid theme issues currently v2.1.3 

```bash
git clone -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
```

#### if already installed

```bash
git -C ~/.config/tmux/plugins/catppuccin/tmux checkout v2.1.3
```

###  Scripts
- approving scripts to be executable

```bash
chmod +x ~/.config/tmux/scripts/*.sh
```

## Misc

### Custom Tmux Input

`tmux-input.sh` — a minimal styled input popup for tmux.

#### Usage

```bash
tmux-input.sh [options] [-- command [args...]]
```

#### Options

| Flag | Description | Default |
|------|-------------|---------|
| `-l, --label TEXT` | Label on the popup border | _(none)_ |
| `-p, --prefix TEXT` | Prompt prefix inside the popup | ` ` |
| `-w, --width SPEC` | Popup width (cells or percent) | `30%` |
| `-h, --height SPEC` | Popup height (cells or percent) | `3` |

#### Examples

```bash
# Rename a tmux window
tmux-input.sh -l "rename window" -- tmux rename-window

# Add a workmux branch
tmux-input.sh -l "new branch" -- workmux add
```

#### Behavior

- Single-line input with full Readline vi keybindings.
- `Escape` or `Ctrl-C` dismisses the popup without running the command.
- `Enter` on non-empty input runs the command with the input appended as the last argument.
- The input is also exported as `$TMUX_INPUT`.
- When no command is given after `--`, the input is printed to stdout.
