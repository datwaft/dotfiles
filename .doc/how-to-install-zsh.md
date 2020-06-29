# How to install zsh

## Step 1: Installing ZSH

```bash
sudo apt-get install zsh
```

## Step 2: Setting ZSH as your default shell

```bash
chsh -s $(which zsh)
```

## Step 3: Installing ohmyzsh

### via curl

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### via wget

```bash
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Step 4: Installing Pure theme

### via NPM

```bash
npm install --global pure-prompt
```

### Manually

#### 1. Cloning the repo into $HOME/.zsh/pure

```bash
mkdir -p "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
```

#### 2. Adding the path of the cloned repo to `$fpath` in `$HOME/.zshrc`

```bash
# .zshrc
fpath+=$HOME/.zsh/pure
```
