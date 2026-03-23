# Laptop Setup

Dotfiles and setup script for a fresh macOS machine.

## What's included

- **Brewfile** — formulae, casks, and CLI tools
- **nvim/** — Neovim config (lazy.nvim + plugins)
- **tmux/** — tmux config with TPM
- **karabiner/** — keyboard remapping (caps lock → ctrl/esc, etc.)
- **zsh/** — .zshrc and aliases (oh-my-zsh + starship)
- **starship/** — prompt config
- **git/** — .gitconfig with delta integration
- **claude/** — Claude Code preferences

## Setup

Clone and run:

```
git clone git@github.com:romeo-alexander/laptop.git ~/laptop
cd ~/laptop && bash setup_laptop.sh
```

After running, set your git email:

```
git config --global user.email "your@email.com"
```

