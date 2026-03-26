-- ── gitsigns.nvim ─────────────────────────────────────────────────────────
-- Gutter signs, inline blame, hunk staging/unstaging/resetting.

local gs = require("gitsigns")

gs.setup({
    signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
    },
    signs_staged = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
    },
    signs_staged_enable = true,

    current_line_blame = false,
    current_line_blame_opts = {
        virt_text         = true,
        virt_text_pos     = "eol",
        delay             = 400,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = "  <author>, <author_time:%Y-%m-%d> · <summary>",

    attach_to_untracked = true,
    watch_gitdir        = { follow_files = true },
    diff_opts           = { algorithm = "histogram" },
})

-- ── Hunk navigation ───────────────────────────────────────────────────────
-- Respects native diff mode (e.g. inside diffview panels); mirrors ]d/[d.

vim.keymap.set("n", "]h", function()
    if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
    else
        gs.nav_hunk("next")
    end
end, { desc = "Next hunk" })

vim.keymap.set("n", "[h", function()
    if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
    else
        gs.nav_hunk("prev")
    end
end, { desc = "Prev hunk" })

-- ── Hunk operations ───────────────────────────────────────────────────────

vim.keymap.set({ "n", "v" }, "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>",   { desc = "Stage hunk" })
vim.keymap.set({ "n", "v" }, "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>",   { desc = "Reset hunk" })
vim.keymap.set("n",          "<leader>gu", gs.undo_stage_hunk,               { desc = "Undo stage hunk" })
vim.keymap.set("n",          "<leader>gS", gs.stage_buffer,                  { desc = "Stage buffer" })
vim.keymap.set("n",          "<leader>gR", gs.reset_buffer,                  { desc = "Reset buffer" })

-- ── Hunk preview + blame ──────────────────────────────────────────────────

vim.keymap.set("n", "<leader>gp", gs.preview_hunk,                           { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame,              { desc = "Toggle inline blame" })
vim.keymap.set("n", "<leader>g~", function() gs.diffthis("HEAD~1") end,      { desc = "Diff vs HEAD~1" })

-- ── Text object: operate on a hunk ────────────────────────────────────────

vim.keymap.set({ "o", "x" }, "ih", "<cmd>Gitsigns select_hunk<cr>",          { desc = "Select hunk" })
