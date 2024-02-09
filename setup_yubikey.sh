#!/bin/bash
set -eo pipefail

if ! command -v ykman &> /dev/null; then
    echo "Installing ykman..."
    brew install ykman
else
    echo "ykman is already installed"
fi

ykman config usb --disable OTP

if ! command -v openssh &> /dev/null; then
    echo "Installing openssh..."
    brew install openssh
else
    echo "openssh is already installed"
fi

if [ ! -f ~/.ssh/ed25519_sk ]; then
    ssh-keygen -t ed25519-sk -C "$RAMP_USERNAME@ramp.com"
else
    echo "Hardware backed SSH key already exists"
fi

gh auth login -h GitHub.com -p ssh
