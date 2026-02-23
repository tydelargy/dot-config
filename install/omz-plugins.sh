#!/bin/bash
set -euo pipefail

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_or_pull() {
    local repo="$1"
    local dest="$2"
    if [[ -d "$dest/.git" ]]; then
        echo "Updating $(basename "$dest")..."
        git -C "$dest" pull --ff-only
    else
        git clone "$repo" "$dest"
    fi
}

clone_or_pull https://github.com/zsh-users/zsh-autosuggestions.git \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
