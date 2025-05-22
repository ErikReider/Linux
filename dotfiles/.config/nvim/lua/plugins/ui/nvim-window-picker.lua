-- Easily jump between NeoVim windows.
return {
    {
        "s1n7ax/nvim-window-picker",
        event = "VeryLazy",
        opts = { filter_rules = { bo = { filetype = { "notify", "incline" } } } },
        config = function(plugin_opts)
            require("window-picker").setup(plugin_opts.opts)

            -- Switch windows
            vim.keymap.set("n", "<leader>w", function()
                local picked_window_id = require("window-picker").pick_window() or
                                             vim.api.nvim_get_current_win()
                vim.api.nvim_set_current_win(picked_window_id)
            end, { desc = "Pick a window" })
        end
    }
}

