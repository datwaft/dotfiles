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

## Step 4: Installing Antigen

```bash
curl -L git.io/antigen > antigen.zsh
```

## Step 5: Installing LS_COLORS

```bash
mkdir /tmp/LS_COLORS && curl -L https://api.github.com/repos/trapd00r/LS_COLORS/tarball/master | tar xzf - --directory=/tmp/LS_COLORS --strip=1
( cd /tmp/LS_COLORS && sh install.sh )
```

