# Neovim Configuration

A minimal Neovim setup for Rust and Python development. No exotic keybind changes, no opinionated workflow plugins — just syntax highlighting, LSP, and completion on top of stock Neovim.

Plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim).

---

## Directory Structure

```
dot-nvim/
├── init.lua                    # Entry point: loads options, plugins, autocmds
├── lua/config/
│   ├── options.lua             # Editor settings (vim.opt)
│   ├── lazy.lua                # Plugin list and lazy.nvim bootstrap
│   └── autocmds.lua            # Autocommands (yank highlight, whitespace trim)
└── after/plugin/
    ├── colors.lua              # Gruvbox theme setup
    ├── treesitter.lua          # Treesitter parser config
    └── lsp.lua                 # LSP, Mason, and completion setup
```

`after/plugin/` files run after all plugins have loaded, avoiding the chicken-and-egg problem of configuring a plugin before it exists.

---

## Plugins

### Theme

#### [gruvbox.nvim](https://github.com/ellisonleao/gruvbox.nvim)
Retro dark color scheme. Configured with `contrast = "hard"` and `background = "dark"`.

---

### Syntax

#### [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
Accurate syntax highlighting and indentation using language-specific parsers rather than regex. Parsers are compiled from C source (requires `gcc`).

Parsers installed automatically:

| Parser | Language |
|---|---|
| `bash` | Shell scripts |
| `json` | JSON |
| `lua` | Lua (Neovim config) |
| `markdown` | Markdown |
| `python` | Python |
| `rust` | Rust |
| `toml` | TOML config files |
| `yaml` | YAML |

---

### LSP

#### [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
Configurations for Neovim's built-in LSP client. Wires each language server to the editor. Requires Neovim 0.10+.

#### [mason.nvim](https://github.com/williamboman/mason.nvim)
Package manager for LSP servers, linters, and formatters. Installs them into `~/.local/share/nvim/mason/`. Open `:Mason` to browse and manage installed tools.

#### [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)
Bridge between Mason and nvim-lspconfig. Ensures the servers listed in the config are installed on startup.

**Configured language servers:**

| Server | Language | Notes |
|---|---|---|
| `rust_analyzer` | Rust | Full IDE features: inlay hints, macro expansion, etc. |
| `pyright` | Python | Static type checking and completion |
| `lua_ls` | Lua | Configured with `vim` as a known global |

---

### Completion

#### [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
Completion menu engine. Aggregates suggestions from multiple sources and presents them in a popup.

**Completion sources (in priority order):**

| Source | Plugin | Provides |
|---|---|---|
| `nvim_lsp` | cmp-nvim-lsp | Language server suggestions |
| `luasnip` | cmp_luasnip | Snippet completions |
| `buffer` | cmp-buffer | Words from open buffers |
| `path` | cmp-path | Filesystem paths |

#### [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
Snippet engine. Required by nvim-cmp for snippet expansion. No custom snippets defined — only used as the cmp snippet backend.

#### [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp), [cmp-buffer](https://github.com/hrsh7th/cmp-buffer), [cmp-path](https://github.com/hrsh7th/cmp-path), [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)
Source adapters that feed data into nvim-cmp.

---

## Keybinds

Only bindings added by this config are listed. All default Neovim bindings remain unchanged.

### LSP (active in buffers with a language server attached)

| Mode | Key | Action |
|---|---|---|
| Normal | `gd` | Go to definition |
| Normal | `K` | Show hover documentation |
| Normal | `[d` | Jump to previous diagnostic |
| Normal | `]d` | Jump to next diagnostic |

### Completion menu (active when popup is open)

| Mode | Key | Action |
|---|---|---|
| Insert | `Ctrl+P` | Select previous item |
| Insert | `Ctrl+N` | Select next item |
| Insert | `Ctrl+Y` | Confirm selection |
| Insert | `Ctrl+Space` | Trigger completion manually |

---

## Editor Options

Set in `lua/config/options.lua`.

| Option | Value | Effect |
|---|---|---|
| `number` + `relativenumber` | true | Hybrid line numbers (absolute current, relative others) |
| `scrolloff` | 8 | Keep 8 lines visible above/below cursor |
| `colorcolumn` | "80" | Highlight column 80 as a line-length guide |
| `tabstop` / `shiftwidth` / `softtabstop` | 4 | 4-space indentation |
| `expandtab` | true | Spaces instead of tab characters |
| `smartindent` | true | Auto-indent on new lines |
| `wrap` | false | No line wrapping |
| `hlsearch` | false | Don't persist search highlights after moving |
| `incsearch` | true | Highlight matches as you type |
| `termguicolors` | true | 24-bit color support |
| `signcolumn` | "yes" | Always show sign column (no layout shift on diagnostics) |
| `updatetime` | 50 | Faster CursorHold events (ms) |
| `swapfile` / `backup` | false | No swap or backup files |
| `undofile` | true | Persistent undo across sessions |

---

## Autocommands

Defined in `lua/config/autocmds.lua`.

| Event | Action |
|---|---|
| `TextYankPost` | Briefly highlight yanked text for 150ms |
| `BufWritePre` | Strip trailing whitespace on every save |

---

## Managing Plugins

lazy.nvim commands (run from inside Neovim):

| Command | Action |
|---|---|
| `:Lazy` | Open plugin manager UI |
| `:Lazy sync` | Install missing, update, clean removed |
| `:Lazy update` | Update all plugins |
| `:Lazy clean` | Remove plugins no longer in the config |
| `:Mason` | Open LSP/tool manager UI |

---

## Requirements

| Requirement | Why |
|---|---|
| Neovim 0.10+ | nvim-lspconfig hard requirement |
| `gcc` / `build-essential` | nvim-treesitter compiles parsers from C source |
| `git` | lazy.nvim clones plugins via git |

Run `bash ~/sources/dot-config/install/nvim.sh` to satisfy all of the above on Ubuntu.
