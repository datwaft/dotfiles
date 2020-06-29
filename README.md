# Please read this

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
