---@module "lazy"

---@type LazySpec
return {
    {
        -- Peek lines just when you intend (peek lines while entering command `:{number}`)
        -- https://github.com/nacro90/numb.nvim
        "nacro90/numb.nvim",
        lazy = false,
        config = true,
    }
}
