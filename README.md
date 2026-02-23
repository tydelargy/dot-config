# dot-config

Personal Ubuntu configuration for a Rust/Python development workstation. Includes atomic install scripts, symlinked dotfiles, and a minimal Neovim IDE setup.

---

## Quick Start

```bash
# 1. Clone the repo
git clone <repo-url> ~/sources/dot-config
cd ~/sources/dot-config

# 2. Install packages (interactive, each step is optional)
bash install.sh

# 3. Link dotfiles into ~/ (also prompts for git identity)
bash create-symlinks.sh

# 4. Log out and back in for shell change to take effect
```

---

## install.sh

Top-level orchestrator. Runs each install script in dependency order with interactive Y/n prompts. Groups:

1. **Shell** — zsh, oh-my-zsh, plugins, powerlevel10k
2. **Dev tools** — git, delta, neovim, rustup
3. **CLI utilities** — fzf, ripgrep, jq, eza, btop
4. **Applications** — Ghostty, 1Password, Claude CLI

Runs a single `apt update` before all apt-based installs. Each script is idempotent: running install.sh again will update existing installs rather than fail.

---

## create-symlinks.sh

Creates symlinks from repo files into the home directory. Backs up any existing real file to `.bak` before overwriting.

| Symlink target | Source |
|---|---|
| `~/.zshrc` | `dot-zshrc` |
| `~/.p10k.zsh` | `dot-p10k.zsh` |
| `~/.gitconfig` | `dot-gitconfig` |
| `~/.config/nvim` | `dot-nvim/` |
| `~/.config/ghostty/config` | `ghostty/config` |
| `~/.claude/CLAUDE.md` | `dot-claude/CLAUDE.md` |
| `~/.claude/settings.json` | `dot-claude/settings.json` |

Also prompts for git name and email, writing them to `~/.gitconfig.local` (excluded from version control via `.gitignore`).

---

## Install Scripts

All scripts live in `install/`. Each is idempotent — safe to re-run for updates.

### Shell

#### `zsh.sh`
Installs [zsh](https://www.zsh.org/) via apt and sets it as the default login shell with `chsh`. Skips both steps if already done.

#### `oh-my-zsh.sh`
Installs [Oh My Zsh](https://ohmyz.sh/) framework. If already installed, runs `omz update` instead.

#### `omz-plugins.sh`
Installs two community plugins into `$ZSH_CUSTOM/plugins/`:

| Plugin | Purpose |
|---|---|
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Fish-style command suggestions as you type |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Real-time syntax highlighting in the prompt |

Clones on first run; runs `git pull --ff-only` on subsequent runs.

#### `p10k.sh`
Installs [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme via shallow clone into `$ZSH_CUSTOM/themes/`. Updates on re-run.

### Development Tools

#### `git.sh`
Installs [git](https://git-scm.com/) via apt.

#### `delta-git.sh`
Installs [delta](https://github.com/dandavison/delta), a syntax-highlighted diff pager. Fetches the latest `.deb` release from the GitHub API and installs with `dpkg`. Used by `dot-gitconfig` as the git pager.

#### `nvim.sh`
Installs [Neovim](https://neovim.io/) 0.10+ via the `neovim-ppa/stable` PPA (the default Ubuntu apt package is pinned to 0.9.x which is insufficient for the plugin ecosystem). Also installs `build-essential` (provides `gcc`, required by nvim-treesitter to compile language parsers) and `python3-neovim`.

#### `rustup.sh`
Installs the [Rust](https://www.rust-lang.org/) toolchain via [rustup](https://rustup.rs/). Runs `rustup update` if already installed. Downloads from `sh.rustup.rs` with TLS 1.2 enforcement.

### CLI Utilities

| Script | Tool | Purpose |
|---|---|---|
| `fzf.sh` | [fzf](https://github.com/junegunn/fzf) | Fuzzy finder for files, history, etc. |
| `rg.sh` | [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast recursive search (`rg`) |
| `jq.sh` | [jq](https://jqlang.github.io/jq/) | JSON processor for the command line |
| `eza.sh` | [eza](https://github.com/eza-community/eza) | Modern `ls` replacement with colors and git status |
| `btop.sh` | [btop](https://github.com/aristocratsoftware/btop) | Rich system resource monitor |

All installed via apt.

### Applications

#### `ghostty.sh`
Installs [Ghostty](https://ghostty.org/) terminal emulator via a third-party Ubuntu installer script.

#### `1pass.sh`
Installs [1Password](https://1password.com/) for Linux. Configures the official apt repository with GPG signature verification.

#### `claude.sh`
Installs [Claude Code](https://claude.ai/claude-code) CLI via the official installer. The `~/.local/bin` directory (where Claude installs itself) is already in PATH via `dot-zshrc`.

---

## Dot Configs

### `dot-zshrc`

Zsh shell configuration. Key features:

- **Theme**: Powerlevel10k with instant prompt
- **Plugins**: git, z, docker, fzf, zsh-autosuggestions, zsh-syntax-highlighting
- **Editor**: `$EDITOR` set to `nvim`
- **Vi mode**: Enabled; `Ctrl+R` for reverse history search
- **History**: 10,000 entries, deduplicated
- **Aliases**:
  - `ls`, `ll`, `la` — remapped to `eza` variants (with icons, git status, etc.)
  - `zshconfig` — opens `~/.zshrc` in nvim
  - `ohmyzsh` — opens `~/.oh-my-zsh` in nvim
- **Functions**:
  - `vf` — fuzzy-find a file and open it in nvim
- **PATH**: Adds `~/.cargo/bin` and `~/.local/bin`

### `dot-p10k.zsh`

[Powerlevel10k](https://github.com/romkatv/powerlevel10k) prompt configuration. Generated by the p10k wizard. Uses Nerd Font v3 glyphs with a powerline-style layout:

- **Left**: current directory, git branch/status
- **Right**: exit status, command duration, background jobs, Rust/Python version indicators

### `dot-gitconfig`

Git configuration. User identity is loaded from `~/.gitconfig.local` (not in this repo — written by `create-symlinks.sh`).

**Pager**: [delta](https://github.com/dandavison/delta) with side-by-side diffs, line numbers, and color-moved detection.

**Aliases**:

| Alias | Command | Description |
|---|---|---|
| `lg` | `log --oneline --graph --decorate --all` | Visual branch graph |
| `last` | `log -1 HEAD` | Show last commit |
| `co` | `checkout` | Shorthand |
| `cob` | `checkout -b` | New branch |
| `cm` | `commit -m` | Commit with message |
| `oops` | `reset --soft HEAD~1` | Undo last commit, keep changes staged |
| `fuck` | `reset --hard HEAD` | Discard all working changes |
| `fap` | `fetch --all --prune` | Fetch and prune all remotes |
| `diff-all` | `diff HEAD` | Diff all changes vs HEAD |
| `diff-stat` | `diff --stat` | Summary of changed files |
| `diff-staged` | `diff --staged` | Diff staged changes |
| `diff-upstream` | `diff @{upstream}` | Diff vs upstream branch |

### `ghostty/config`

[Ghostty](https://ghostty.org/) terminal configuration:

- **Theme**: Firewatch
- **Font**: JetBrains Mono, size 10
- **Cursor**: Block
- **Window**: 96% opacity, dark background `#1C2021`, balanced padding
- **Shell integration**: No-cursor, sudo passthrough, 25% cell height adjustment

**Keybinds** (prefix: `Ctrl+S`):

| Keybind | Action |
|---|---|
| `Ctrl+S R` | Reload config |
| `Ctrl+S Z` | Toggle split zoom |
| `Ctrl+S E` | Equalize splits |
| `Ctrl+S X` | Close surface |

---

## Claude Code Config

### `dot-claude/CLAUDE.md`

Persistent instructions for Claude Code. Specifies stack (Rust/Python), preferred tools (`cargo nextest`, `rg`, `nvim`, `eza`), coding conventions, and workflow rules (never auto-push, never rebase without instruction).

### `dot-claude/settings.json`

Permission allowlist/denylist for Claude Code tool calls:

- **Allowed**: `echo`, `git log/status/diff`, `jq`, `wc`, `cargo *`, `pytest`
- **Denied**: `git push`, `git reset`, `git rebase`

---

## Neovim

See [`dot-nvim/README.md`](dot-nvim/README.md) for the full plugin and keybind reference.
