# How to install tmux

## Install dependencies

```shell
sudo apt-get install -y libevent-dev ncurses-dev build-essential bison pkg-config
```

## Get tmux from Github

Go to <https://github.com/tmux/tmux/releases> and get the latest release like this:

```shell
mkdir ~/downloads 2> /dev/null; cd ~/downloads
wget https://github.com/tmux/tmux/releases/download/3.1c/tmux-3.1c.tar.gz
tar -zxf tmux-3.1c.tar.gz && cd tmux-3.1c
./configure
make && sudo make install
```

## Install Tmux Package Manager

These instructions are extracted from: <https://github.com/tmux-plugins/tpm>

```shell
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
