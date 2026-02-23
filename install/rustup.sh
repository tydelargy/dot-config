#!/bin/bash
set -euo pipefail

if command -v rustup &>/dev/null; then
    echo "Rust already installed, updating..."
    rustup update
else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # Source cargo env for the version check below
    # shellcheck source=/dev/null
    source "$HOME/.cargo/env"
fi

rustc --version
