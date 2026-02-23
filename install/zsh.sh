#!/bin/bash
set -euo pipefail

# Install zsh if not already present
if ! command -v zsh &>/dev/null; then
    sudo apt install zsh -y
else
    echo "zsh already installed: $(zsh --version)"
fi

# Set zsh as default shell only if it isn't already
CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"
ZSH_PATH="$(which zsh)"

if [[ "$CURRENT_SHELL" != "$ZSH_PATH" ]]; then
    chsh -s "$ZSH_PATH"
    echo "Default shell changed to zsh. Log out and back in for this to take effect."
else
    echo "zsh is already the default shell."
fi
