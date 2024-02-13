#!/bin/zsh
set -eo pipefail

(( $+commands[ykman])) ||  brew install ykman

ykman config usb --force --disable OTP

[[ $(which ssh) = *"homebrew"* ]] || {
    brew install openssh
    reset
}


(( $+RAMP_USERNAME )) || {
    read "RAW_RAMP_USERNAME?Enter your ramp username: " 
    export RAMP_USERNAME=$(echo $RAW_RAMP_USERNAME | cut -d "@" -f 1)
}

[[ -s "~/.ssh/id_ed25519_sk" ]] || ssh-keygen -t ed25519-sk -C "$RAMP_USERNAME@ramp.com"

touch ~/.ssh/config

cat << "EOF" > ~/.ssh/config
Host github.com
    HostName github.com
    IdentitiesOnly yes
    IdentityFile ~/.ssh/id_ed25519_sk
EOF

unset GH_TOKEN # Unset GH_TOKEN if it exists

gh auth login -h github.com -p ssh

echo "Click on 'Configure SSO' and authorize the Ramp organization at
at https://github.com/settings/keys"

open "https://github.com/settings/keys"

ssh -T "git@github.com"
