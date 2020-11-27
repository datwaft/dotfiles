# Alpine Linux after installation documentation

Here is what to do after installing Alpine Linux to use these dotfiles.

This document was created because I wanted to learn how to use Alpine Linux.

## Create a user

```shell
# Create a user named 'datwaft'
adduser -h /home/datwaft -s /bin/ash datwaft
```

## Install sudo and add user to sudoers

```shell
# Install sudo
apk add sudo
# Add group wheel to sudoers group
echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel
# Add user to wheel group
adduser datwaft wheel
```

After that it's recommended to restart the OS.

## Change root password

```shell
passwd
```

## Installing dependencies

```shell
sudo apk add ncurses ncurses-dev make cmake mercurial git ninja gettext libtool autoconf automake pkgconfig unzip icu icu-dev
```
