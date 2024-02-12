#!/bin/bash
set -eo pipefail

if ! command -v ykman &> /dev/null; then
    echo "Installing ykman..."
    brew install ykman
else
    echo "ykman is already installed"
fi

ykman config usb --disable OTP

if [[ ! $(which ssh) =~ "homebrew" ]]; then
    echo "Installing openssh..."
    brew install openssh
    reset
else
    echo "brew version of openssh is already installed"
fi

if [[ -z "$RAMP_USERNAME" ]]; then
    read -p "Enter your ramp username: " RAW_RAMP_USERNAME 
    # Strip e-mail domain
    export RAMP_USERNAME=$(echo $RAW_RAMP_USERNAME | cut -d "@" -f 1)
fi

if [ ! -f ~/.ssh/id_ed25519_sk ]; then
    ssh-keygen -t ed25519-sk -C "$RAMP_USERNAME@ramp.com"
else
    echo "Hardware backed SSH key already exists"
fi

touch ~/.ssh/config

cat << "EOF" > ~/.ssh/config
Host github.com
    HostName github.com
    IdentitiesOnly yes
    IdentityFile ~/.ssh/id_ed25519_sk
EOF

unset GH_TOKEN # Unset GH_TOKEN if it exists

gh auth login -h github.com -p ssh

echo "Testing yubikey-backed SSH connection to github.com..."

ssh -T git@github.com
