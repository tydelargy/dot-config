#!/bin/bash
set -euo pipefail

if command -v delta &>/dev/null; then
    echo "delta already installed: $(delta --version)"
    exit 0
fi

echo "Fetching latest delta release..."
DEB_URL=$(curl -fsSL https://api.github.com/repos/dandavison/delta/releases/latest \
    | grep "browser_download_url" \
    | grep "amd64.deb" \
    | cut -d'"' -f4)

if [[ -z "$DEB_URL" ]]; then
    echo "Error: could not determine latest delta release URL." >&2
    exit 1
fi

TMP=$(mktemp --suffix=.deb)
curl -fsSL "$DEB_URL" -o "$TMP"
sudo dpkg -i "$TMP"
rm -f "$TMP"

delta --version
