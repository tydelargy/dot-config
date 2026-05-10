#!/bin/bash
set -euo pipefail

REPO_DIR="$HOME/.local/share/ticket"

if command -v tk &>/dev/null && [[ -d "$REPO_DIR" ]]; then
    echo "Updating tk..."
    git -C "$REPO_DIR" pull
    tk --version
    exit 0
fi

git clone --depth=1 https://github.com/wedow/ticket.git "$REPO_DIR"

mkdir -p "$HOME/.local/bin"
ln -sf "$REPO_DIR/ticket" "$HOME/.local/bin/tk"

tk --version
