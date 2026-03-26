-- ── diffview.nvim ─────────────────────────────────────────────────────────
-- Tabbed diff views, file history browser, merge conflict resolution.

local actions = require("diffview.actions")

require("diffview").setup({
    enhanced_diff_hl = true,
    use_icons        = true,

    keymaps = {
        view = {
            { "n", "]h", actions.next_entry, { desc = "Next hunk" } },
            { "n", "[h", actions.prev_entry, { desc = "Prev hunk" } },
        },
        file_panel = {
            { "n", "s",  actions.toggle_stage_entry, { desc = "Stage/unstage file" } },
            { "n", "S",  actions.stage_all,           { desc = "Stage all" } },
            { "n", "U",  actions.unstage_all,         { desc = "Unstage all" } },
            { "n", "X",  actions.restore_entry,       { desc = "Restore file" } },
        },
        merge_tool = {
            { "n", "<leader>mc", actions.conflict_choose("ours"),   { desc = "Choose ours" } },
            { "n", "<leader>mt", actions.conflict_choose("theirs"), { desc = "Choose theirs" } },
            { "n", "<leader>mb", actions.conflict_choose("base"),   { desc = "Choose base" } },
            { "n", "<leader>ma", actions.conflict_choose("all"),    { desc = "Choose all" } },
            { "n", "]x",         actions.next_conflict,             { desc = "Next conflict" } },
            { "n", "[x",         actions.prev_conflict,             { desc = "Prev conflict" } },
        },
    },

    hooks = {
        diff_buf_win_enter = function(_, _, ctx)
            if ctx.layout_name:match("^diff") then
                vim.opt_local.number         = false
                vim.opt_local.relativenumber = false
            end
        end,
    },
})

-- ── Keymaps ───────────────────────────────────────────────────────────────

vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>",             { desc = "Diff working tree vs HEAD" })
vim.keymap.set("n", "<leader>ge", "<cmd>DiffviewOpen --staged<cr>",    { desc = "Diff staged vs HEAD" })
vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewOpen origin/master<cr>", { desc = "Diff vs master" })
vim.keymap.set("n", "<leader>gL", "<cmd>DiffviewOpen HEAD~1..HEAD<cr>",  { desc = "Last commit diff" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",    { desc = "File history" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>",      { desc = "Repo history" })
vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<cr>",            { desc = "Close diffview" })
