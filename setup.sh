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

# Remove existing .zshrc and .oh-my-zsh before installation
rm -rf $HOME/.oh-my-zsh
rm $HOME/.zshrc


# Install oh-my-zsh and plugins
RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/you-should-use

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

brew install lazygit oven-sh/bun/bun gh mkcert ripgrep neovim

