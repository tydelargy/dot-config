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

### Inlay Hints

Inlay hints are enabled automatically in every LSP buffer. They render inline, greyed-out annotations in the editor without occupying a column.

| Hint type | Languages | Example |
|---|---|---|
| Type hints | All | `let x/*: i32*/ = 1 + 1` |
| Parameter names | All | `foo(/*value:*/ 42)` |
| Chaining hints | All | Annotates intermediate types in method chains |
| Closure return types | All | `\|x\| /*-> bool*/ x > 0` |
| Lifetime elision hints | Rust | Shows inferred lifetimes on references |
| Reborrow hints | Rust | Shows `&mut` reborrows (mutable only, to reduce noise) |

To toggle hints off temporarily: `:lua vim.lsp.inlay_hint.enable(false)`

### Completion menu (active when popup is open)

| Mode | Key | Action |
|---|---|---|
| Insert | `Ctrl+P` | Select previous item |
| Insert | `Ctrl+N` | Select next item |
| Insert | `Ctrl+Y` | Confirm selection |
| Insert | `Ctrl+Space` | Trigger completion manually |

---

## Essential Neovim Basics

All of the below are stock Neovim — nothing added by this config.

### Modes

Neovim is modal: keys do different things depending on the current mode.

| Mode | How to enter | Indicator |
|---|---|---|
| Normal | `Esc` from anywhere | Default mode |
| Insert | `i` (before cursor), `a` (after cursor) | `-- INSERT --` |
| Visual | `v` (character), `V` (line), `Ctrl+V` (block) | `-- VISUAL --` |
| Command | `:` from Normal | `:` prompt at bottom |

### Saving and Quitting

| Command | Action |
|---|---|
| `:w` | Save (write) |
| `:q` | Quit (fails if unsaved changes) |
| `:wq` or `:x` | Save and quit |
| `:q!` | Quit without saving |
| `:wqa` | Save and quit all open buffers |

### Navigation (Normal mode)

| Key | Action |
|---|---|
| `h` `j` `k` `l` | Left / down / up / right |
| `w` | Jump forward to start of next word |
| `b` | Jump backward to start of previous word |
| `e` | Jump to end of current word |
| `0` | Jump to start of line |
| `$` | Jump to end of line |
| `gg` | Jump to first line of file |
| `G` | Jump to last line of file |
| `{number}G` | Jump to line number (e.g. `42G`) |
| `Ctrl+D` | Scroll half-page down |
| `Ctrl+U` | Scroll half-page up |
| `%` | Jump to matching bracket/paren/brace |

### Jump List (navigation history)

| Key | Action |
|---|---|
| `Ctrl+O` | Go back in jump history |
| `Ctrl+I` | Go forward in jump history |

Useful after `gd` (go to definition) to return to where you were.

### Editing (Normal mode)

| Key | Action |
|---|---|
| `x` | Delete character under cursor |
| `dd` | Delete (cut) current line |
| `yy` | Yank (copy) current line |
| `p` | Paste after cursor |
| `P` | Paste before cursor |
| `u` | Undo |
| `Ctrl+R` | Redo |
| `o` | Open new line below and enter Insert |
| `O` | Open new line above and enter Insert |
| `r` | Replace single character under cursor |
| `ciw` | Change inner word (delete word, enter Insert) |
| `cc` | Change entire line |
| `.` | Repeat last change |

### Operators + Motions

Operators combine with motions: `{operator}{motion}`.

| Operator | Meaning |
|---|---|
| `d` | Delete (cut) |
| `y` | Yank (copy) |
| `c` | Change (delete + enter Insert) |

Examples:
- `dw` — delete to end of word
- `d$` — delete to end of line
- `y3j` — yank current line plus 3 lines down
- `ci"` — change text inside quotes
- `da(` — delete text including surrounding parens

### Search

| Key | Action |
|---|---|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` | Next match |
| `N` | Previous match |
| `*` | Search for word under cursor (forward) |
| `#` | Search for word under cursor (backward) |

### Visual Mode

Select text, then apply an operator:

| Key | Action |
|---|---|
| `v` | Enter character-wise visual |
| `V` | Enter line-wise visual |
| `Ctrl+V` | Enter block visual (column select) |
| `d` | Delete selection |
| `y` | Yank selection |
| `>` / `<` | Indent / dedent selection |

### Windows and Buffers

| Command / Key | Action |
|---|---|
| `:e {file}` | Open file in current window |
| `:vs {file}` | Open file in vertical split |
| `:sp {file}` | Open file in horizontal split |
| `Ctrl+W W` | Cycle between windows |
| `Ctrl+W H/J/K/L` | Move focus left/down/up/right |
| `:bn` / `:bp` | Next / previous buffer |
| `:bd` | Close current buffer |
| `:ls` | List open buffers |

### Command-line Tips

| Key | Action |
|---|---|
| `Ctrl+R` (in Insert mode) | Reverse search shell history (via zsh vi mode) |
| `Tab` | Autocomplete file/command names in `:` prompt |
| `Up` / `Down` | Cycle command history in `:` prompt |

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
| Neovim 0.10+ | nvim-lspconfig requires 0.10+ |
| `gcc` / `build-essential` | nvim-treesitter compiles parsers from C source |
| `git` | lazy.nvim clones plugins via git |
| Node.js / `npm` | Mason uses npm to install pyright |

Run `bash ~/sources/dot-config/install/nvim.sh` to satisfy all of the above on Ubuntu.
