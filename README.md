# Please read this

The way this repository uses for storing my dotfiles is with a _bare_ repository. This makes it easy to clone, and it doesn't need to use system links.

> The technique consists in storing a Git bare repository in a "side" folder (like `$HOME/.cfg` or `$HOME/.myconfig`) using a specially crafted alias so that commands are run against that repository and not the usual `.git` local folder, which would interfere with any other Git repositories around.

## FAQ (Frequently Asked Questions)

### What are the pre-requisites for this?

Install `git`.

### How do I import the dotfiles?

Use this command:

```sh
git clone --bare git@github.com:datwaft/dotfiles.git $HOME/.dotfiles
```

> This will clone the contents of the remote repository (the .git link) to the home directory (~) while referencing ~/.dotfiles as the local bare repository (the `—seperate-git-dir` part).

After that add the alias to the current shell scope:

```sh
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

And after that do a checkout to add the files to the home directory:

```sh
dotfiles checkout
```

And add this to make it ignore files it doesn't have:

```sh
dotfiles config --local status.showUntrackedFiles no
```

**Warning:** Your home directory shouldn't contain any of the dotfiles present inside the directory.

### Where did you get the information for using your dotfiles like this?

Here: <https://www.atlassian.com/git/tutorials/dotfiles>

And Here: <https://martijnvos.dev/using-a-bare-git-repository-to-store-linux-dotfiles/>
