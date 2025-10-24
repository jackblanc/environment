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

# Prompt for machine type if not already set
if [ ! -f "$PWD/.machine_type" ]; then
	echo ""
	echo "==================================="
	echo "Machine Type Configuration"
	echo "==================================="
	echo "What type of machine is this?"
	echo "  1) personal-mac    - Personal MacBook Pro"
	echo "  2) work-mac        - Work MacBook Pro (local)"
	echo "  3) work-ec2        - Work EC2 Instance (remote)"
	echo ""
	read "choice?Enter choice (1-3): "

	case $choice in
		1) MACHINE_TYPE="personal-mac" ;;
		2) MACHINE_TYPE="work-mac" ;;
		3) MACHINE_TYPE="work-ec2" ;;
		*) echo "Invalid choice. Please run setup again." && exit 1 ;;
	esac

	echo $MACHINE_TYPE > "$PWD/.machine_type"
	echo "Machine type set to: $MACHINE_TYPE"
	echo ""
else
	MACHINE_TYPE=$(cat "$PWD/.machine_type")
	echo "Machine type already set to: $MACHINE_TYPE"
fi

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
		if [ "$MACHINE_TYPE" = "work-ec2" ]; then
			echo "Skipping Cursor setup on EC2 instance."
		elif [ "$OS" = "Darwin" ]; then
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

	# Skip Ghostty config on EC2
	if [ "$name" = "ghostty" ] && [ "$MACHINE_TYPE" = "work-ec2" ]; then
		echo "Skipping Ghostty setup on EC2 instance."
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

	# Define packages - skip ghostty on EC2
	PACKAGES="lazygit oven-sh/bun/bun gh mkcert ripgrep neovim bat fzf eza"
	if [ "$MACHINE_TYPE" != "work-ec2" ]; then
		PACKAGES="$PACKAGES ghostty"
	fi

	# Install packages using Homebrew (idempotent - only installs if missing)
	for package in $PACKAGES; do
		if brew list $package &>/dev/null; then
			echo "$package is already installed."
		else
			echo "Installing $package..."
			brew install $package
		fi
	done
else
	# Linux-specific package installation using apt
	# eza is available from deb.gierens.de, key must be added
	if [ ! -f /etc/apt/keyrings/gierens.gpg ]; then
		echo "Adding eza repository..."
		sudo mkdir -p /etc/apt/keyrings
		wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
		echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
		sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
	else
		echo "eza repository already configured."
	fi

	# Install packages
	echo "Installing packages using apt..."
	sudo DATABRICKS_ALLOW_INSTALL=1 apt update
	sudo DATABRICKS_ALLOW_INSTALL=1 apt install -y \
		ripgrep \
		neovim \
		bat \
		fzf \
		eza
	echo "All packages installed or updated via apt."

	# The bat package is installed as batcat, link to bat
	mkdir -p ~/.local/bin
	if [ ! -f /usr/bin/bat ]; then
		sudo ln -sf /usr/bin/batcat /usr/bin/bat
	fi

	# LazyGit must be installed directly
	if ! command -v lazygit >/dev/null 2>&1; then
		LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
		echo "Installing LazyGit version $LAZYGIT_VERSION"
		curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
		tar xf lazygit.tar.gz lazygit
		sudo install lazygit -D -t /usr/local/bin/
		rm lazygit lazygit.tar.gz
	else
		echo "lazygit is already installed."
	fi
fi

source $HOME/.zshrc
