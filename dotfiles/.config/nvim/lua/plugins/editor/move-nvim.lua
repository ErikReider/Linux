---@module "lazy"


---@type LazySpec
return {
    ---@module "move"
    {
        -- Gain the power to move lines and blocks and auto-indent them!
        -- https://github.com/fedepujol/move.nvim
        "fedepujol/move.nvim",
        lazy = false,
        config = true,
    },
}
