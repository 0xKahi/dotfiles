# Linux Setup

- [docker setup](https://docs.docker.com/desktop/setup/install/linux/archlinux/)

## Symlink LY

```bash
sudo ln -s $(pwd)/ly/config.ini /etc/ly/config.ini
sudo systemctl enable ly@tty2.service
```

## Symlink Keyd

```bash
sudo ln -s $(pwd)/keyd/default.conf /etc/keyd/default.conf
sudo systemctl enable --now keyd
```
