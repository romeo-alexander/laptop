#!/bin/zsh
set -eo pipefail

(( $+commands[ykman])) ||  brew install ykman
