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

    -- which-key: keybinding popup helper
    { "folke/which-key.nvim", event = "VeryLazy" },

    -- Telescope: fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Treesitter: accurate syntax highlighting and indentation.
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },

    -- LSP: language server support.
    { "neovim/nvim-lspconfig" },

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
