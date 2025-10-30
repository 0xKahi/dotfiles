# Brew Setup

## Initial Setup

install `leaves` and `casks`

```sh
xargs brew install < brew/leaves.txt
xargs brew install --cask < brew/casks.txt
```

## Migration for mac to new machine  

```sh
brew leaves > brew/leaves.txt
brew list --cask > brew/casks.txt
```
