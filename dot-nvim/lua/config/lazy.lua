-- ── Bootstrap lazy.nvim ───────────────────────────────────────────────────

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugin list ───────────────────────────────────────────────────────────
-- Plugin-specific config lives in after/plugin/<name>.lua

require("lazy").setup({

    -- Gruvbox dark theme
    { "ellisonleao/gruvbox.nvim", priority = 1000 },

    -- Treesitter: accurate syntax highlighting and indentation.
    -- Pinned to v0.9.3 for nvim 0.9.x compatibility.
    -- After upgrade to nvim 0.10+, this pin can be removed.
    {
        "nvim-treesitter/nvim-treesitter",
        tag = "v0.9.3",
        build = ":TSUpdate",
    },

    -- LSP: language server support.
    -- Pinned to last commit before nvim 0.10 became a hard requirement.
    -- Pin can be removed after upgrading to nvim 0.10+.
    { "neovim/nvim-lspconfig", commit = "cb33dea6" },

    -- Mason: installs and manages LSP servers, linters, formatters
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    -- Completion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },   -- LSP completions
    { "hrsh7th/cmp-buffer" },     -- completions from open buffers
    { "hrsh7th/cmp-path" },       -- filesystem path completions
    { "L3MON4D3/LuaSnip" },       -- snippet engine (required by nvim-cmp)
    { "saadparwaiz1/cmp_luasnip" },

})
