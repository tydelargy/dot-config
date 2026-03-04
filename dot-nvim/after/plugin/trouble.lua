require("trouble").setup({
    auto_refresh = true,
    focus        = false,
    keys = {
        q   = "close",
        ["<esc>"] = "close",
    },
})

-- ── Keymaps ───────────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",               { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics" })
vim.keymap.set("n", "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>",            { desc = "LSP references" })
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                   { desc = "Quickfix list" })

-- Cycle through errors only (ERROR severity). Distinct from ]d/[d which cycle all severities.
vim.keymap.set("n", "<leader>xn", function()
    vim.diagnostic.jump({ count = 1,  float = true, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })
vim.keymap.set("n", "<leader>xp", function()
    vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Prev error" })

-- ── Periodic refresh ──────────────────────────────────────────────────────
vim.fn.timer_start(2000, function()
    if require("trouble").is_open() then
        require("trouble").refresh()
    end
end, { ["repeat"] = -1 })
