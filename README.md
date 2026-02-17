# Dotfiles

This repository stores dotfiles using [`jj-vcs` (Jujutsu)](https://jj-vcs.dev/) as the version control tool. The working tree is the home directory (`~`) itself, so no symlinks are needed.

## Prerequisites

- Install `git`.
- Install `jj`.

## Importing the dotfiles

Create `~/.gitignore` before initializing so jj doesn't try to snapshot the entire home directory:

```sh
echo '*' > ~/.gitignore
```

Initialize a bare jj repo (git backend in `~/.dotfiles`, workspace in `~`). The `--config` flag prevents it from trying to snapshot all of `~` during init:

```sh
git init --bare ~/.dotfiles
jj git init --git-repo=~/.dotfiles ~ --config snapshot.auto-track='none()'
jj config set --repo snapshot.auto-track 'none()'
```

Add the remote, fetch, and check out `main`:

```sh
jj git remote add origin git@github.com:datwaft/dotfiles.git
jj git fetch
jj bookmark track main --remote origin
jj new main
```

## Usage

This setup means you can use `jj` anywhere in your home directory and it will work.

If you are inside another repository `jj` will use that repository instead, which is the expected behaviour as we don't want to accidentally add files inside another repository to this repository.

As we are ignoring all files by default which means we need to explicitly track files using `jj file track --include-ignored`. This repository has an abbreviation for adding `--include-ignored` automatically.

## How it works

- `jj` uses a bare git repo in `~/.dotfiles` so any tool that is not configured to work with `jj` will not detect a git repository in the home directory. This is something we want to avoid performance implications.
- You need to use `jj file track --include-ignored` to track files as the files are not being tracked automatically. This is a protection measure to prevent accidentally tracking files.
