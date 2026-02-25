-- Treesitter: parser installation.
-- nvim-treesitter v1.0 + nvim 0.11: the plugin only manages parser installation.
-- Highlighting and indentation are built-in to nvim 0.11+.
-- install() skips already-installed parsers by default.

require("nvim-treesitter.install").install({
    "bash", "json", "lua", "markdown", "python", "rust", "toml", "yaml",
})
