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

# Detect the OS
OS=$(uname)
echo "Detected OS: $OS"

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
	
	if [ "$name" = "cursor" ]; then
		if [ "$OS" = "Darwin" ]; then
			# MacOS-specific cursor setup
			mkdir -p "$HOME/Library/Application Support/Cursor/User"
			link "config/cursor/settings.json" "Library/Application Support/Cursor/User/settings.json"
			link "config/cursor/keybindings.json" "Library/Application Support/Cursor/User/keybindings.json"
			# Link to VSCode too    
			mkdir -p "$HOME/Library/Application Support/Code/User"
			link "config/cursor/settings.json" "Library/Application Support/Code/User/settings.json"
			link "config/cursor/keybindings.json" "Library/Application Support/Code/User/keybindings.json"
		else
			echo "Skipping cursor setup on Linux."
		fi
		continue
	fi
	
	# Normal config linking
	link config/$name .config/$name
done

# Package management
if [ "$OS" = "Darwin" ]; then
	# Check if Homebrew is already installed
	if command -v brew >/dev/null 2>&1; then
		echo "Homebrew is already installed."
	else
		echo "Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		echo "Homebrew installation complete."
	fi

	# Install or upgrade packages using Homebrew
	for package in lazygit oven-sh/bun/bun gh mkcert ripgrep neovim ghostty bat fzf eza; do
		if brew list $package &>/dev/null; then
			echo "Upgrading $package..."
			brew upgrade $package
		else
			echo "Installing $package..."
			brew install $package
		fi
	done
else
	# Linux-specific package installation using apt
	echo "Installing packages using apt..."
	sudo apt update
	sudo apt install -y \
		lazygit \
		bun \
		gh \
		mkcert \
		ripgrep \
		neovim \
		bat \
		fzf \
		exa  # 'eza' alternative in apt is 'exa'
	echo "All packages installed or updated via apt."
fi

source $HOME/.zshrc
