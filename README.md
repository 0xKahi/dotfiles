# Dotfiles

### Install with stow:
```bash
stow --target .
```

### to source zshrc config in `~/.zshrc`

```bash
if [ -r ~/.config/zsh/.zshrc ]; then
    source ~/.config/zsh/.zshrc
fi
```
