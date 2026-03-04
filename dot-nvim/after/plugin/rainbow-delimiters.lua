-- Rainbow delimiters: color-coded matching brackets via treesitter
local rainbow = require("rainbow-delimiters")

vim.g.rainbow_delimiters = {
    strategy  = {
        [""] = rainbow.strategy["global"],
        vim = rainbow.strategy["local"],
    },
    query     = {
        [""] = "rainbow-delimiters",
        lua = "rainbow-blocks",
    },
    highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
    },
}
