-- Gain the power to move lines and blocks and auto-indent them!
return {
    {
        "fedepujol/move.nvim",
        lazy = false,
        config = function()
            require("move").setup({})
        end,
    },
}
