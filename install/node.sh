#!/bin/bash
set -euo pipefail

# The Ubuntu apt package for nodejs is severely outdated.
# NodeSource ships the current LTS release.

if command -v node &>/dev/null; then
    echo "node $(node --version) already installed."
    exit 0
fi

curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

node --version
npm --version
