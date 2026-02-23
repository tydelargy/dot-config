#!/bin/bash
set -euo pipefail

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

if [[ -d "$P10K_DIR/.git" ]]; then
    echo "Powerlevel10k already installed, updating..."
    git -C "$P10K_DIR" pull --ff-only
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi
