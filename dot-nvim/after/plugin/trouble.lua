require("trouble").setup({})

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",               { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics" })
vim.keymap.set("n", "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>",            { desc = "LSP references" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                   { desc = "Quickfix list" })
