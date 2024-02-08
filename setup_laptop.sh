#!/bin/bash
set -eo pipefail

## Install Homebrew
if ! command -v brew &> /dev/null; then
    "Installing Homebrew..."
    # Fetch and execute Homebrew installation script
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to the PATH for future sessions
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/romeo/.zprofile

    # Activate Homebrew in the current shell session
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # To uninstall Homebrew, run the following command:
    # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
else
    echo "Homebrew is already installed"
fi

if ! command -v brew &> /dev/null; then
    echo "Installing gh..."
    brew install gh
else
    echo "gh is already installed"
fi

# Install iterm2 Terminal emulator
if [ -z $(mdfind "kMDItemCFBundleIdentifier == com.googlecode.iterm2") ]; then
    echo "Installing iterm2..."
    brew install --cask iterm2
else
    echo "iterm2 is already installed"
fi

# Install Visual Studio Code
if ! command -v code &> /dev/null; then
    echo "Installing vscode..."
    brew install --cask visual-studio-code
else
    echo "vscode is already installed"
fi

# Install pipx
if ! command -v pipx &> /dev/null; then
    echo "Installing pipx..."
    brew install pipx
else
    echo "pipx is already installed"
fi

# Ensure that pipx is in the PATH
pipx ensurepath > /dev/null 2>&1

# Recommended git aliases https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status


# Install Oh My Zsh
if [ ! -f ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   
    # To uninstall Oh My Zsh, run the following command:
    # uninstall_oh_my_zsh 
else
    echo "Oh My Zsh is already installed"
fi
