#!/bin/zsh

PWD=$(pwd)
echo $PWD
echo $HOME

link() {
	SOURCE=$PWD/$1
	DEST=$HOME/$2
	echo "Linking $SOURCE to $DEST"
	rm -rf $DEST
	ln -s $SOURCE $DEST
}

clone_or_pull() {
    REPO_URL=$1
    TARGET_DIR=$2
    if [ -d "$TARGET_DIR" ]; then
        echo "Updating $(basename $TARGET_DIR)..."
        cd "$TARGET_DIR"
        git pull
        cd - > /dev/null
    else
        echo "Cloning $(basename $REPO_URL)..."
        git clone --depth=1 "$REPO_URL" "$TARGET_DIR"
    fi
}

# Install oh-my-zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed"
fi

# Remove existing .zshrc to ensure clean configuration
rm -f $HOME/.zshrc

# Install/update themes and plugins
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# Powerlevel10k theme
clone_or_pull https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k"

# Plugins
clone_or_pull https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

clone_or_pull https://github.com/MichaelAquilina/zsh-you-should-use.git \
    "$ZSH_CUSTOM/plugins/you-should-use"

# home 
for file in $PWD/home/*(D); do
  name=${file##*/}
  link home/$name $name
done

# configs
mkdir -p $HOME/.config
for file in $PWD/config/*; do
  name=${file##*/}
  link config/$name .config/$name
done

source $HOME/.zshrc

# Check if Homebrew is already installed
if command -v brew >/dev/null 2>&1; then
    echo "Homebrew is already installed."
else
    echo "Installing Homebrew..."
    # Use non-interactive installation of Homebrew to avoid overwriting existing files
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installation complete."
fi

# Install or upgrade packages
for package in lazygit oven-sh/bun/bun gh mkcert ripgrep neovim ghostty; do
    if brew list $package &>/dev/null; then
        echo "Upgrading $package..."
        brew upgrade $package
    else
        echo "Installing $package..."
        brew install $package
    fi
done

