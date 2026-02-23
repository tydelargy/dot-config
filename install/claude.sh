#!/bin/bash
set -euo pipefail

# dot-zshrc already adds ~/.local/bin to PATH; no need to append here.
curl -fsSL https://claude.ai/install.sh | bash

echo "Claude installed. Ensure ~/.local/bin is in PATH (dot-zshrc handles this)."
