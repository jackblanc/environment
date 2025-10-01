# AGENTS.md

Agent guidance for working with this personal environment configuration repository.

## Build/Lint/Test Commands
- No build, lint, or test commands (shell config repo)
- Run `./setup.sh` to install and configure the entire environment
- Test changes by sourcing: `source ~/.zshrc`

## Code Style Guidelines

### Shell Scripts
- Use `#!/bin/zsh` for shell scripts
- Use tabs for indentation in shell scripts
- Functions: lowercase with underscores (e.g., `clone_or_pull()`, `link()`)
- Variables: UPPERCASE for globals, lowercase for locals
- Echo status messages for user feedback during setup

### Configuration Files
- JSON: 2-space indentation (Cursor/VSCode settings)
- Lua: 2-space indentation (Neovim config)
- Use symlinks via `link()` function for all config files
- Preserve existing conventions in each config format
