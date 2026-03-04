-- Treesitter: parser installation.
-- nvim-treesitter v1.0 + nvim 0.11: the plugin only manages parser installation.
-- Highlighting and indentation are built-in to nvim 0.11+.
-- install() skips already-installed parsers by default.

local parsers = { "bash", "json", "lua", "markdown", "markdown_inline", "python", "rust", "toml", "yaml" }

require("nvim-treesitter.install").install(parsers)

vim.api.nvim_create_autocmd("FileType", {
    pattern = parsers,
    callback = function() vim.treesitter.start() end,
})
