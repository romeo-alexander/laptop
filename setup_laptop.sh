#!/bin/bash

## Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    # Fetch and execute Homebrew installation script
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to the PATH for future sessions
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile

    # Activate Homebrew in the current shell session
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # To uninstall Homebrew, run the following command:
    # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
else
    echo "Homebrew is already installed"
fi

# Install Oh My Zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # To uninstall Oh My Zsh, run the following command:
    # uninstall_oh_my_zsh
else
    echo "Oh My Zsh is already installed"
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

## Restore Brew dependencies
echo "Installing Brew dependencies from Brewfile..."
brew bundle install --file="$SCRIPT_DIR/Brewfile"

## Symlink configs
echo "Symlinking configs..."

# tmux
ln -sf "$SCRIPT_DIR/tmux/.tmux.conf" ~/.tmux.conf

# neovim
mkdir -p ~/.config ~/.config/karabiner ~/.claude
ln -sfn "$SCRIPT_DIR/nvim" ~/.config/nvim

# karabiner
ln -sf "$SCRIPT_DIR/karabiner/karabiner.json" ~/.config/karabiner/karabiner.json

# zsh
ln -sf "$SCRIPT_DIR/zsh/.zshrc" ~/.zshrc
ln -sf "$SCRIPT_DIR/zsh/.zaliases" ~/.zaliases

# git
ln -sf "$SCRIPT_DIR/git/.gitconfig" ~/.gitconfig

# starship
ln -sf "$SCRIPT_DIR/starship/starship.toml" ~/.config/starship.toml

# claude
ln -sf "$SCRIPT_DIR/claude/CLAUDE.md" ~/.claude/CLAUDE.md

## iTerm2: load preferences from this repo
# Points iTerm2 at iterm/com.googlecode.iterm2.plist so settings (font, colors,
# keybinds) are versioned here. Requires an iTerm2 restart to take effect.
if [[ -d "$SCRIPT_DIR/iterm" ]]; then
    echo "Configuring iTerm2 to load prefs from $SCRIPT_DIR/iterm ..."
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$SCRIPT_DIR/iterm"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
fi

echo "Done."
