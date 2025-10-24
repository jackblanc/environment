# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal development environment configuration repository containing:
- Shell configurations (zsh with Oh My Zsh, custom aliases)
- Editor configurations (Neovim with lazy.nvim, Cursor/VSCode settings)
- Terminal emulator configuration (Ghostty)
- Automated setup scripts for macOS and Linux
- Machine-type based dynamic configuration system

## Key Commands

### Setup and Installation
- `./setup.sh` - Main setup script that installs and configures the entire environment
  - Prompts for machine type on first run (personal-mac, work-mac, work-ec2)
  - Writes machine type to `.machine_type` (gitignored)
  - Idempotent - safe to run multiple times
  - Automatically installs Oh My Zsh, themes, plugins, and development tools
  - Links configuration files to their appropriate locations
  - Skips GUI tools (Ghostty, Cursor) on EC2 instances

### Development Tools Available
- `lazygit` or `lg` - Git interface
- `bat` - Enhanced cat command (aliased to `cat`)
- `eza` - Modern ls replacement with various aliases (`ls`, `ll`, `la`, `lt`, `tree`)
- `fzf` - Fuzzy finder
- `ripgrep` - Fast search tool
- `neovim` - Text editor
- `gh` - GitHub CLI

### Common Aliases
**Base aliases** (from `custom/aliases` - loaded on all machines):
- `g` - git
- `lg` - lazygit
- `cde` - cd ~/environment
- `cdr` - cd ~/projects/reservations
- `cat` - bat (enhanced cat with syntax highlighting)
- `ls`, `ll`, `la`, `lt`, `tree` - eza variants

**Work aliases** (from `custom/aliases.work` - loaded on work-mac and work-ec2):
- `gs` - git stack
- `cdu` - cd ~/universe
- `claude` - llm agent session

**Machine-specific aliases** (from `custom/aliases.<machine-type>`):
- `aliases.personal-mac` - Personal MacBook specific
- `aliases.work-mac` - Work MacBook specific
- `aliases.work-ec2` - EC2 instance specific

## Architecture

### Configuration Structure
- `config/` - Application configurations
  - `cursor/` - Cursor/VSCode settings and keybindings
  - `nvim/` - Neovim configuration using lazy.nvim
  - `ghostty/` - Terminal emulator config
- `custom/` - Custom shell configurations
  - `aliases` - Base aliases (loaded on all machines)
  - `aliases.work` - Work-specific aliases (work-mac and work-ec2)
  - `aliases.personal-mac` - Personal Mac specific aliases
  - `aliases.work-mac` - Work Mac specific aliases
  - `aliases.work-ec2` - EC2 specific aliases
  - `history` - Shell history configuration
- `home/` - Files that get symlinked to home directory
  - `.gitconfig` - Personal git config (default)
  - `.gitconfig-work` - Work git config (auto-loaded in ~/universe/)
  - `.zshrc` - Main shell configuration
- `.machine_type` - Machine identifier (gitignored, created by setup.sh)

### Neovim Configuration
- Uses lazy.nvim plugin manager
- Key plugins: nvim-tree, telescope, treesitter, LSP with Mason
- Leader key: `<space>`
- LSP keybindings: `gd` (go to definition), `K` (hover), `<leader>rn` (rename), `<leader>ca` (code action)
- File explorer: `<leader>e`
- Fuzzy finder: `<leader>ff` (files), `<leader>fg` (grep), `<leader>fb` (buffers)
- Git diff: `<leader>dv` (open), `<leader>dc` (close), `<leader>dh` (history)

### Cursor/VSCode Configuration
- Vim mode enabled with `<space>` as leader
- Zen mode settings configured
- Format on save enabled
- Key bindings: `K` (hover), `<leader>ra` (rename), `<leader>lg` (lazygit), `<leader>ff` (quick open)
- Relative line numbers enabled

### Machine Type System
The repository uses a machine-type based configuration system to support multiple environments:

**Machine Types:**
- `personal-mac` - Personal MacBook Pro (local development)
- `work-mac` - Work MacBook Pro (local development)
- `work-ec2` - Work EC2 instance (remote development)

**How it works:**
1. Run `./setup.sh` and select your machine type
2. Machine type is saved to `.machine_type` (gitignored)
3. `.zshrc` loads the machine type and exports `$MACHINE_TYPE` environment variable
4. Aliases are loaded in order:
   - Base aliases (all machines)
   - Work aliases (if machine type starts with "work-")
   - Machine-specific aliases
   - User secrets/env (`~/.secrets`)

**To change machine type:**
```bash
rm .machine_type
./setup.sh
```

### Git Configuration Strategy
The repository uses git's conditional includes to support both personal and work git identities:

**Default behavior:**
- Personal git config (`.gitconfig`) is used everywhere by default
- Contains personal email: `jackblanc0@icloud.com`

**Work repositories:**
- Work git config (`.gitconfig-work`) auto-loads for repos in `~/universe/`
- Contains work email: `jack.blanc@databricks.com`
- Configured via `includeIf "gitdir:~/universe/"` in `.gitconfig`

**This allows:**
- Using personal git credentials for this environment repo (even on work machines)
- Automatic switch to work credentials when working in `~/universe/`
- No manual switching required

### Setup Script Functionality
- Cross-platform support (macOS with Homebrew, Linux with apt)
- Prompts for machine type on first run
- Idempotent - safe to run multiple times (checks before installing)
- Installs development tools: lazygit, bun, gh, mkcert, ripgrep, neovim, ghostty (skip on EC2), bat, fzf, eza
- Sets up Oh My Zsh with Powerlevel10k theme and useful plugins
- Creates symlinks for all configuration files
- Handles OS-specific paths (especially for Cursor on macOS)
- Skips GUI tools on EC2 instances

## File Management
- The setup script uses a `link()` function to create symlinks from this repo to home directory
- Configurations are organized by application in the `config/` directory
- The script removes existing files before creating new symlinks to ensure clean configuration