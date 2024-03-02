# `datwaft` dotfiles

> [!CAUTION]
> There could be conflicts if you already have any of the files in this
> repository in your machine.

## Requirements

You need to have installed `git` and `stow`.

## How do I install these dotfiles?

```sh
# First clone the repository
git clone git@github.com:datwaft/dotfiles.git ~/.dotfiles
# Then we enter the created repository
cd ~/.dotfiles
# And finally we use the stow command
stow .
```

## How do I solve conflicts?

You have multiple options.

The first way is removing the file that is causing the conflict:

```sh
rm ~/.zshrc
```

Another way is by using the `--adopt` flag (be careful as this modifies the dotfiles repository):

```sh
stow . --adopt
```
