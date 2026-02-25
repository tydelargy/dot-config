-- ── Editor options ────────────────────────────────────────────────────────

vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.scrolloff      = 8

vim.opt.tabstop        = 4
vim.opt.softtabstop    = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true
vim.opt.smartindent    = true

vim.opt.wrap           = false
vim.opt.hlsearch       = false  -- don't keep search highlights after moving
vim.opt.incsearch      = true   -- highlight as you type

vim.opt.termguicolors  = true
vim.opt.signcolumn     = "yes"
vim.opt.colorcolumn    = "80"
vim.opt.updatetime     = 50     -- faster cursor hold / gutter updates

vim.opt.swapfile       = false
vim.opt.backup         = false
vim.opt.undofile       = true
vim.opt.undodir        = vim.fn.stdpath("data") .. "/undodir"

-- Keybinds

vim.g.mapleader = " "
vim.keymap.set("n", "<leader><leader>", vim.cmd.Ex)
