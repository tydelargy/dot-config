-- ── Highlight on yank ─────────────────────────────────────────────────────
-- Briefly highlights yanked text so you can see what was copied.

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("HighlightYank", {}),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    end,
})

-- ── Strip trailing whitespace on save ─────────────────────────────────────

vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("StripTrailingWS", {}),
    pattern = "*",
    command = [[%s/\s\+$//e]],
})
