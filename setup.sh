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


# Prevent the installer from replacing the shell
RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install zsh-syntax-highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

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

