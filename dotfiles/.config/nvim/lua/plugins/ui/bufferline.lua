-- Bufferline
return {
    {
        "romgrk/barbar.nvim",
        opts = {
            animation = true,
            auto_hide = false,
            tabpages = true,
            closable = true,
            clickable = true,
            exclude_ft = { "dap-repl" },
            icons = {
                button = "",
                modified = { button = "●" },
                filetype = { enabled = true },
                pinned = { button = "車" },
                separator = { left = "" },
                inactive = { separator = { left = "" } },
            },
            icon_custom_colors = false,
            insert_at_end = false,
            insert_at_start = false,
            maximum_padding = 1,
        },
    },
}
