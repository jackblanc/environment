# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting you-should-use)
source $ZSH/oh-my-zsh.sh

# Powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Source custom files
for f in $HOME/environment/custom/*; do source $f; done

# Source machine-specific, untracked file in $HOME/.secrets
[ -s $HOME/.secrets ] && source $HOME/.secrets

# bun
[ -s "/Users/jackblanc/.bun/_bun" ] && source "/Users/jackblanc/.bun/_bun"

# sst
export SST_STAGE=local

# Neovim 
export PATH=/Users/jackblanc/.nvim/bin:$PATH
export EDITOR='nvim'
export VISUAL='nvim'

