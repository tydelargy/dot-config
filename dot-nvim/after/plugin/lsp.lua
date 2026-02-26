-- ── LSP + Mason + Completion ──────────────────────────────────────────────
--
-- mason.nvim            — installs/updates language servers
-- mason-lspconfig       — ensures servers are installed on launch
-- nvim-lspconfig        — configures each language server
-- nvim-cmp              — completion menu (LSP + buffer + path sources)
--
-- Open :Mason to manage installed servers interactively.

-- ── Capabilities (shared by all servers) ──────────────────────────────────
-- Advertises nvim-cmp completion capabilities to every LSP server.

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- ── Keymaps (active only in buffers with an LSP attached) ─────────────────
-- Navigation only — no workflow changes.

local on_attach = function(_, bufnr)
    local o = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "gd",  vim.lsp.buf.definition,  vim.tbl_extend("force", o, { desc = "Go to definition" }))
    vim.keymap.set("n", "K",   vim.lsp.buf.hover,        vim.tbl_extend("force", o, { desc = "Hover docs" }))
    vim.keymap.set("n", "[d",  vim.diagnostic.goto_prev, vim.tbl_extend("force", o, { desc = "Previous diagnostic" }))
    vim.keymap.set("n", "]d",  vim.diagnostic.goto_next, vim.tbl_extend("force", o, { desc = "Next diagnostic" }))

    -- Inlay hints (type hints, parameter names, lifetimes) — nvim 0.10+ API.
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
end

-- ── Server definitions ────────────────────────────────────────────────────
-- Add extra per-server settings in the nested table.

local servers = {
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                inlayHints = {
                    typeHints          = { enable = true },
                    chainingHints      = { enable = true },
                    parameterHints     = { enable = true },
                    -- "always" shows hints even for trivial cases; use "skip_trivial" to reduce noise
                    lifetimeElisionHints = { enable = "always", useParameterNames = true },
                    -- "mutable" shows hints only for mutable reborrows; "always" shows all
                    reborrowHints      = { enable = "mutable" },
                    closureReturnTypeHints = { enable = "always" },
                },
            },
        },
    },
    pyright       = {},
    lua_ls = {
        settings = {
            Lua = { diagnostics = { globals = { "vim" } } },
        },
    },
}

-- ── Mason setup ───────────────────────────────────────────────────────────

require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = vim.tbl_keys(servers),
    automatic_enable = true,
})

-- ── Configure each server (nvim 0.11+ API) ────────────────────────────────
-- vim.lsp.config merges with lspconfig's base configs (cmd, root_dir, etc.).
-- vim.lsp.enable is called by mason-lspconfig via automatic_enable.

for server, extra in pairs(servers) do
    vim.lsp.config(server, vim.tbl_deep_extend("force", {
        capabilities = capabilities,
        on_attach    = on_attach,
    }, extra))
end

vim.diagnostic.config({ virtual_text = true })

-- ── Completion ────────────────────────────────────────────────────────────

local cmp     = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"]     = cmp.mapping.select_prev_item(),
        ["<C-n>"]     = cmp.mapping.select_next_item(),
        ["<C-y>"]     = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    }),
})
