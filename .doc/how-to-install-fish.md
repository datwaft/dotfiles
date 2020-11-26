# How to install fish shell

## Installation

### Installation from bleeding edge

```shell
mdkir ~/downloads; cd ~/downloads
git clone https://github.com/fish-shell/fish-shell.git && cd fish-shell
cmake .
make
sudo make install
```

### Installation from package manager

This kind of installation depends on your Linux distribution. You can read the instructions [here](https://fishshell.com/#get_fish_linux).

## Dependencies

### Fisher plugin manager

```shell
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
```
