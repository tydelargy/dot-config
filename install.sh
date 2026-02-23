#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$SCRIPT_DIR/install"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

header() { echo -e "\n${BOLD}${BLUE}==> $1${NC}"; }
ok()     { echo -e "  ${GREEN}✓${NC} $1"; }
skip()   { echo -e "  ${YELLOW}~${NC} $1 (skipped)"; }
err()    { echo -e "  ${RED}✗${NC} $1"; }

ask() {
    local prompt="$1"
    local reply
    read -rp "  Install/update ${prompt}? [Y/n] " reply
    [[ "${reply:-y}" =~ ^[Yy] ]]
}

run() {
    local script="$1"
    local name="$2"
    if ask "$name"; then
        echo ""
        bash "$INSTALL_DIR/$script" && ok "$name" || err "$name failed (continuing)"
    else
        skip "$name"
    fi
}

echo ""
echo -e "${BOLD}Ubuntu Dot-Config Installer${NC}"
echo "=================================="
echo "Each component can be installed or skipped individually."
echo "Scripts are idempotent — safe to re-run for updates."

# Single apt update pass up front
header "Updating package lists"
sudo apt update -qq

# ── Shell ──────────────────────────────────────────────────────────────────────
header "Shell"
run "zsh.sh"         "Zsh"
run "oh-my-zsh.sh"   "Oh My Zsh"
run "omz-plugins.sh" "OMZ plugins (autosuggestions, syntax-highlighting)"
run "p10k.sh"        "Powerlevel10k theme"

# ── Development ────────────────────────────────────────────────────────────────
header "Development tools"
run "git.sh"       "Git"
run "delta-git.sh" "delta (git diff viewer)"
run "nvim.sh"      "Neovim"
run "rustup.sh"    "Rust toolchain"

# ── CLI utilities ──────────────────────────────────────────────────────────────
header "CLI utilities"
run "fzf.sh"  "fzf (fuzzy finder)"
run "rg.sh"   "ripgrep"
run "jq.sh"   "jq (JSON processor)"
run "eza.sh"  "eza (ls replacement)"
run "btop.sh" "btop (system monitor)"

# ── Applications ───────────────────────────────────────────────────────────────
header "Applications"
run "ghostty.sh" "Ghostty terminal"
run "1pass.sh"   "1Password"
run "claude.sh"  "Claude CLI"

echo ""
echo -e "${BOLD}${GREEN}Done!${NC}"
echo ""

# Remind about shell change
if command -v zsh &>/dev/null; then
    CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"
    if [[ "$CURRENT_SHELL" != "$(which zsh)" ]]; then
        echo -e "${YELLOW}Note:${NC} Your default shell was changed to zsh — log out and back in."
    fi
fi

echo "Run ./create-symlinks.sh to link dot-configs into place."
echo ""
