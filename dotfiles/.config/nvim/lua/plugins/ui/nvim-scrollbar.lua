-- Extensible Neovim Scrollbar
return {
    {
        "petertriho/nvim-scrollbar",
        opts = {
            set_highlights = true,
            hide_if_all_visible = true,
            throttle_ms = 100,
            handle = { text = " ", highlight = "StatusLine", hide_if_all_visible = true },
            handlers = {
                cursor = true,
                diagnostic = true,
                gitsigns = false,
                handle = true,
                search = false,
                ale = false,
            },
        },
    },
}
