#!/bin/bash
set -euo pipefail

if vcommand -v obsidian &>/dev/null; then
    echo "Obsidian already installed: $(obsidian --version)"
    exit 0
fi


echo "Fetching obsidian"
DEB_URL="https://github.com/obsidianmd/obsidian-releases/releases/download/v1.12.4/obsidian_1.12.4_amd64.deb"

TMP=$(mktemp --suffix=.deb)
curl -fsSL "$DEB_URL" -o "$TMP"
sudo dpkg -i "$TMP"

rm -rf "$TMP"

# Create base vault
mkdir -p "$HOME/notes"

echo "Obsidian now installed - recommended to insall *Minmal* theme and set $HOME/notes as your valut"
