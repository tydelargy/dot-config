-- Treesitter: better syntax highlighting and indentation.
-- Using v0.9.3 API (configs module). Pin in lazy.lua can be removed
-- after upgrading to nvim 0.10+.

require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash", "json", "lua", "markdown", "python", "rust", "toml", "yaml",
    },
    sync_install  = false,
    auto_install  = true,
    highlight     = { enable = true },
    indent        = { enable = true },
})
