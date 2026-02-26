local wk = require("which-key")
wk.setup({})
wk.add({
    { "<leader>f", group = "telescope" },
    { "<leader>v", group = "vim" },
    { "<leader>x", group = "trouble" },
})
