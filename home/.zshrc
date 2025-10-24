# Detect OS
OS=$(uname)

# Load machine type
if [ -f "$HOME/environment/.machine_type" ]; then
    export MACHINE_TYPE=$(cat "$HOME/environment/.machine_type")
else
    export MACHINE_TYPE="unknown"
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

# Source custom files in order
# 1. Base aliases (shared by all machines)
[ -f "$HOME/environment/custom/aliases" ] && source "$HOME/environment/custom/aliases"

# 2. Work-specific aliases (shared by work-mac and work-ec2)
if [[ "$MACHINE_TYPE" == work-* ]]; then
    [ -f "$HOME/environment/custom/aliases.work" ] && source "$HOME/environment/custom/aliases.work"
fi

# 3. Machine-specific aliases
[ -f "$HOME/environment/custom/aliases.$MACHINE_TYPE" ] && source "$HOME/environment/custom/aliases.$MACHINE_TYPE"

# 4. History configuration
[ -f "$HOME/environment/custom/history" ] && source "$HOME/environment/custom/history"

# 5. Machine-specific secrets/env (untracked file in $HOME/.secrets)
[ -s "$HOME/.secrets" ] && source "$HOME/.secrets"


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
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client@8.4/bin:$PATH"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

tmux_universe_init() {
  tmux new-session -d -s u1 -c ~/universe
  tmux new-session -d -s u2 -c ~/u2
  tmux new-session -d -s u3 -c ~/u3
}


