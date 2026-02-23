#!/bin/bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

ok()     { echo -e "  ${GREEN}✓${NC} $1 → $2"; }
backup() { echo -e "  ${YELLOW}~${NC} Backed up existing $1 → $1.bak"; }

link() {
    local src="$1"
    local dst="$2"

    mkdir -p "$(dirname "$dst")"

    # If the target exists and is not already a symlink, back it up
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        mv "$dst" "${dst}.bak"
        backup "$dst"
    fi

    ln -sf "$src" "$dst"
    ok "$src" "$dst"
}

# Prompt for git identity and write ~/.gitconfig.local (never committed).
setup_git_identity() {
    local local_cfg="$HOME/.gitconfig.local"
    local current_name="" current_email=""

    if [[ -f "$local_cfg" ]]; then
        current_name="$(git config --file "$local_cfg" user.name 2>/dev/null || true)"
        current_email="$(git config --file "$local_cfg" user.email 2>/dev/null || true)"
        echo ""
        echo "  Current git identity:"
        echo "    name:  ${current_name:-(unset)}"
        echo "    email: ${current_email:-(unset)}"
        read -rp "  Update git identity? [y/N] " update
        [[ "${update:-n}" =~ ^[Yy] ]] || return 0
    fi

    local name email
    read -rp "  Git user.name:  " name
    read -rp "  Git user.email: " email

    printf '[user]\n\tname = %s\n\temail = %s\n' "$name" "$email" > "$local_cfg"
    echo -e "  ${GREEN}✓${NC} Written ~/.gitconfig.local (not tracked by git)"
}

echo ""
echo -e "${BOLD}Creating dot-config symlinks${NC}"
echo "=============================="

# Shell
link "$REPO/dot-zshrc"     "$HOME/.zshrc"
link "$REPO/dot-p10k.zsh"  "$HOME/.p10k.zsh"

# Git — dot-gitconfig includes ~/.gitconfig.local for identity
link "$REPO/dot-gitconfig"  "$HOME/.gitconfig"
echo ""
echo -e "  ${BOLD}Git identity${NC} (stored in ~/.gitconfig.local, never committed)"
setup_git_identity

# Neovim
link "$REPO/dot-nvim" "$HOME/.config/nvim"

# Ghostty — config lives under ~/.config/ghostty/
link "$REPO/ghostty/config" "$HOME/.config/ghostty/config"

# Claude Code — link individual files so ~/.claude/ can still hold
# project history and other Claude-managed state
link "$REPO/dot-claude/CLAUDE.md"      "$HOME/.claude/CLAUDE.md"
link "$REPO/dot-claude/settings.json"  "$HOME/.claude/settings.json"

echo ""
echo -e "${BOLD}${GREEN}Done!${NC} Existing files were backed up with a .bak suffix."
echo ""
