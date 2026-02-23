#!/bin/bash
set -euo pipefail

# The Ubuntu apt package for neovim is severely outdated (0.9.x).
# The official stable PPA ships 0.10.x which is required by the current
# plugin ecosystem (nvim-lspconfig, nvim-treesitter, etc.).

if command -v nvim &>/dev/null; then
    CURRENT=$(nvim --version | head -1 | grep -oP '\d+\.\d+')
    MAJOR=$(echo "$CURRENT" | cut -d. -f1)
    MINOR=$(echo "$CURRENT" | cut -d. -f2)
    if [[ "$MAJOR" -gt 0 || "$MINOR" -ge 10 ]]; then
        echo "nvim $CURRENT already installed and up to date."
        exit 0
    fi
    echo "nvim $CURRENT detected — upgrading to 0.10+ via PPA."
fi

sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo apt update
sudo apt install neovim python3-neovim -y

nvim --version | head -1
