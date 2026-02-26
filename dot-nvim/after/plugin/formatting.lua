-- ── Formatting via conform.nvim ────────────────────────────────────────────

require("conform").setup({
    formatters_by_ft = {
        json     = { "prettier" },
        markdown = { "prettier" },
    },
    format_on_save = {
        timeout_ms = 2000,
        lsp_format = "fallback",
    },
})
