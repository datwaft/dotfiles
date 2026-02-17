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

Initialize a colocated jj repo, add the remote, fetch, and check out `main`:

```sh
jj git init ~
jj config set --repo snapshot.auto-track 'none()'
jj git remote add origin git@github.com:datwaft/dotfiles.git
jj git fetch
jj bookmark track main --remote origin
jj new main
```

## Usage

This setup means you can use `jj` anywhere in your home directory and it will work.

If you are inside another repository `jj` will use that repository instead, which is the expected behaviour as we don't want to accidentally add files inside another repository to this repository.

As we are ignoring all files by default and set `snapshot.auto-track` to `none()` we need to explicitly track files using `jj file track --include-ignored`.

## How it works

- `jj` uses a colocated workspace: both `.jj` and `.git` exist in `~`.
- `*` in `~/.gitignore` makes jj skip all files during snapshotting, so operations are fast even with a large home directory.
- Files are tracked explicitly with `jj file track --include-ignored <path>`. Already-tracked files remain tracked regardless of ignore patterns.
