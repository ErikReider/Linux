---@module "lazy"

---@type LazySpec
return {
    {
        -- TODO: Use https://github.com/brenoprata10/nvim-highlight-colors instead
        "catgoose/nvim-colorizer.lua",
        main = "colorizer",
        opts = {
            -- Enable for all filetypes.
            -- Gets disabled when lsp supports document_color in on_attach.
            "*",
        },
    },
}
