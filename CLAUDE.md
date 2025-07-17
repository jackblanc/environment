# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal development environment configuration repository containing:
- Shell configurations (zsh with Oh My Zsh, custom aliases)
- Editor configurations (Neovim with lazy.nvim, Cursor/VSCode settings)
- Terminal emulator configuration (Ghostty)
- Automated setup scripts for macOS and Linux

## Key Commands

### Setup and Installation
- `./setup.sh` - Main setup script that installs and configures the entire environment
- Automatically installs Oh My Zsh, themes, plugins, and development tools
- Links configuration files to their appropriate locations

### Development Tools Available
- `lazygit` or `lg` - Git interface
- `bat` - Enhanced cat command (aliased to `cat`)
- `eza` - Modern ls replacement with various aliases (`ls`, `ll`, `la`, `lt`, `tree`)
- `fzf` - Fuzzy finder
- `ripgrep` - Fast search tool
- `neovim` - Text editor
- `gh` - GitHub CLI

### Common Aliases (from custom/aliases)
- `g` - git
- `lg` - lazygit
- `cursor` - Open Cursor editor in current directory
- `cde` - cd ~/environment
- `cdu` - cd ~/universe
- `cdr` - cd ~/projects/reservations

## Architecture

### Configuration Structure
- `config/` - Application configurations
  - `cursor/` - Cursor/VSCode settings and keybindings
  - `nvim/` - Neovim configuration using lazy.nvim
  - `ghostty/` - Terminal emulator config
- `custom/` - Custom shell configurations
  - `aliases` - Shell aliases
  - `history` - Shell history
- `home/` - Files that get symlinked to home directory

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

### Setup Script Functionality
- Cross-platform support (macOS with Homebrew, Linux with apt)
- Installs development tools: lazygit, bun, gh, mkcert, ripgrep, neovim, ghostty, bat, fzf, eza
- Sets up Oh My Zsh with Powerlevel10k theme and useful plugins
- Creates symlinks for all configuration files
- Handles OS-specific paths (especially for Cursor on macOS)

## File Management
- The setup script uses a `link()` function to create symlinks from this repo to home directory
- Configurations are organized by application in the `config/` directory
- The script removes existing files before creating new symlinks to ensure clean configuration