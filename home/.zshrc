# Detect OS
OS=$(uname)

# Set terminal type for Linux
if [ "$OS" = "Linux" ]; then
    export TERM="xterm-256color"
fi

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting you-should-use)
source $ZSH/oh-my-zsh.sh

# Powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Homebrew (MacOS-specific)
if [ "$OS" = "Darwin" ]; then
    if [ -x "$HOME/homebrew/bin/brew" ]; then
        eval "$($HOME/homebrew/bin/brew shellenv)"
    fi

    # bun
    [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
fi

# Source custom files
for f in $HOME/environment/custom/*; do source $f; done

# Source machine-specific, untracked file in $HOME/.secrets
[ -s $HOME/.secrets ] && source $HOME/.secrets


# fzf
if [ "$OS" = "Linux" ]; then
    source /usr/share/doc/fzf/examples/completion.zsh
    source /usr/share/doc/fzf/examples/key-bindings.zsh
elif command -v fzf &>/dev/null; then
    source <(fzf --zsh)
fi

if [ "$OS" = "Linux" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# sst
export SST_STAGE=local

# Neovim
export PATH="$HOME/.nvim/bin:$PATH"
export EDITOR='nvim'
export VISUAL='nvim'

export PATH="/opt/homebrew/bin:$PATH"

# bun completions
[ -s "/Users/jackblanc/.bun/_bun" ] && source "/Users/jackblanc/.bun/_bun"
export PATH="/Users/jackblanc/.bun/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client@8.4/bin:$PATH"


# opencode
export PATH=/Users/jackblanc/.opencode/bin:$PATH
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
