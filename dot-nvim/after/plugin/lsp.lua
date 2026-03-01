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
-- Uses LspAttach autocmd — idiomatic nvim 0.11 pattern.

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(ev)
        local bufnr = ev.buf
        local o = { buffer = bufnr, silent = true }
        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", o, { desc = desc }))
        end

        -- Navigation
        map("n", "gd",  vim.lsp.buf.definition,      "Go to definition")
        map("n", "gD",  vim.lsp.buf.declaration,      "Go to declaration")
        map("n", "go",  vim.lsp.buf.type_definition,  "Go to type definition")
        map("n", "K",   vim.lsp.buf.hover,            "Hover docs")

        -- Find (0.11 gr-prefix conventions)
        map("n", "grr", vim.lsp.buf.references,       "References")
        map("n", "gri", vim.lsp.buf.implementation,   "Implementation")
        map("n", "gO",  vim.lsp.buf.document_symbol,  "Document symbols")

        -- Actions
        map("n",          "grn", vim.lsp.buf.rename,       "Rename symbol")
        map({ "n", "v" }, "gra", vim.lsp.buf.code_action,  "Code action")

        -- Signature help (insert mode)
        map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

        -- Diagnostics
        map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
        map("n", "]d", function() vim.diagnostic.jump({ count =  1, float = true }) end, "Next diagnostic")
        map("n", "gl", vim.diagnostic.open_float, "Open diagnostic float")

        -- Inlay hints (type hints, parameter names, lifetimes) — nvim 0.10+ API.
        if vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        -- Document highlight (when server supports textDocument/documentHighlight)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client.supports_method("textDocument/documentHighlight") then
            local hl = vim.api.nvim_create_augroup("lsp_doc_highlight_" .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                group = hl, buffer = bufnr,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                group = hl, buffer = bufnr,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
})

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
    jsonls        = {},
    bashls        = {},
    marksman      = {},
    clangd        = {},
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
    }, extra))
end

-- ── Document-highlight appearance ─────────────────────────────────────────
-- Override the three LSP reference groups so they use a background fill
-- (like a visual selection) instead of the theme's default underline/fg tint.
-- Runs once on startup and again after every colorscheme change.

local function set_lsp_ref_highlights()
    vim.api.nvim_set_hl(0, "LspReferenceText",  { link = "Visual" })
    vim.api.nvim_set_hl(0, "LspReferenceRead",  { link = "Visual" })
    vim.api.nvim_set_hl(0, "LspReferenceWrite", { link = "Visual" })
end
set_lsp_ref_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_lsp_ref_highlights })

vim.diagnostic.config({
    virtual_text     = { source = "if_many", prefix = "●" },
    signs            = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.HINT]  = "󰌶",
            [vim.diagnostic.severity.INFO]  = "",
        },
    },
    float            = { border = "rounded", source = true },
    severity_sort    = true,
    update_in_insert = false,
    underline        = true,
})

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
