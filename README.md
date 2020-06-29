# Please read this

The way this repository uses for storing my dotfiles is with a _bare_ repository. This makes it very easily clonable, and it doesn't need to use system links.

> The technique consists in storing a Git bare repository in a "side" folder (like `$HOME/.cfg` or `$HOME/.myconfig`) using a specially crafted alias so that commands are run against that repository and not the usual `.git` local folder, which would interfere with any other Git repositories around.

## FAQ (Frequently Asked Questions)

### How do I import the dotfiles?

Use this command:

```bash
git clone --separate-git-dir=~/.dotfiles https://github.com/datwaft/dotfiles.git ~
```

> This will clone the contents of the remote repository (the .git link) to the home directory (~) while referencing ~/.dotfiles as the local bare repository (the —seperate-git-dir part).

**Warning:** Your home directory shouldn't containt any of the dotfiles present inside the directory.

### Where did you get the information for using your dotfiles like this?

Here: https://www.atlassian.com/git/tutorials/dotfiles

And Here: https://martijnvos.dev/using-a-bare-git-repository-to-store-linux-dotfiles/
