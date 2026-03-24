local additional_filetypes = { "heex", "blade" }

---@type LazySpec[]
return {
    -- Changing tag name also changed matching tag
    {
        -- NOTE: Needed for Elixir heex files
        "AndrewRadev/tagalong.vim",
        enabled = true,
        ft = {
            "eco",
            "eelixir",
            "ejs",
            "eruby",
            "html",
            "htmldjango",
            "javascriptreact",
            "jsx",
            "php",
            "typescriptreact",
            "xml",
            unpack(additional_filetypes),
        },
        init = function()
            vim.g.tagalong_additional_filetypes = additional_filetypes
        end,
    },
}
