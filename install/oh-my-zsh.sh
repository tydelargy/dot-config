#!/bin/bash
set -euo pipefail

if [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo "Oh My Zsh already installed, updating..."
    "$HOME/.oh-my-zsh/tools/upgrade.sh"
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

omz version
