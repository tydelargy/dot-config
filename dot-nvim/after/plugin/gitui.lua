-- ── gitui floating terminal ───────────────────────────────────────────────
-- Opens gitui in a centered floating window (90% of the editor viewport).
-- Closes automatically when gitui exits.

local function open_gitui()
    local width  = math.floor(vim.o.columns * 0.90)
    local height = math.floor(vim.o.lines   * 0.90)
    local buf    = vim.api.nvim_create_buf(false, true)

    local win = vim.api.nvim_open_win(buf, true, {
        relative  = "editor",
        width     = width,
        height    = height,
        row       = math.floor((vim.o.lines   - height) / 2),
        col       = math.floor((vim.o.columns - width)  / 2),
        style     = "minimal",
        border    = "rounded",
        title     = " gitui ",
        title_pos = "center",
    })

    vim.fn.termopen("gitui", {
        on_exit = function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
            if vim.api.nvim_buf_is_valid(buf) then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end,
    })

    vim.cmd.startinsert()
end

vim.keymap.set("n", "<leader>gg", open_gitui, { desc = "Open gitui" })
