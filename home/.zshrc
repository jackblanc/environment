# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

eval "$(/opt/homebrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

alias g='git'

# bun completions
[ -s "/Users/jackblanc/.bun/_bun" ] && source "/Users/jackblanc/.bun/_bun"

# sst
export PATH=/Users/jackblanc/.sst/bin:$PATH
export SST_STAGE=local

# cloudflare
export CLOUDFLARE_API_TOKEN=eHvNjHIOn6iVkhloYOQ__vtJrNBf9jWeWC2TQrLE

# nvmim
export PATH=/Users/jackblanc/.nvim/bin:$PATH
export EDITOR='nvim'
export VISUAL='nvim'

export ANTHROPIC_API_KEY="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"

export STRIPE_API_KEY="sk_test_51PIlJQJ48Myylpy8ljR6N9azZ392E9SWYFe6dSEwVaSBMAveyQXELnJusnahRkH5yrZ46W8CGTfaMA1q83dmFz3v00wYqzPDKc"

