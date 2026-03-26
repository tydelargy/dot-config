local wk = require("which-key")
wk.setup({})
wk.add({
    { "<leader>f", group = "telescope" },
    { "<leader>g", group = "git" },
    { "<leader>m", group = "merge" },
    { "<leader>v", group = "vim" },
    { "<leader>x", group = "trouble" },
    { "g",         group = "lsp / goto" },
    { "gr",        group = "lsp actions" },
})
