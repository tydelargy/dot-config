#!/bin/bash
set -euo pipefail

APPIMAGE="nvim-linux-x86_64.appimage"

curl -fsSL -o "$APPIMAGE" "https://github.com/neovim/neovim/releases/download/v0.11.6/nvim-linux-x86_64.appimage"

chmod u+x "$APPIMAGE"
mkdir -p "$HOME/.local/bin"
mv "$APPIMAGE" "$HOME/.local/bin/nvim"

# Check version
nvim --version
