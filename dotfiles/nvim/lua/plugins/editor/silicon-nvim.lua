return {
    {
        "krivahtoo/silicon.nvim",
        build = "./install.sh build",
        event = { "BufReadPre", "BufNewFile" },
        cmd = { "Silicon" },
        opts = {
            font = "FiraCode Nerd Font=16",
            theme = "vscode",
            output = {
                -- (string) The full path of the file to save to.
                file = "",

                -- (boolean) Whether to copy the image to clipboard instead of saving to file.
                clipboard = true,
                -- (string) Where to save images, defaults to the current directory.
                --  e.g. /home/user/Pictures
                path = vim.fn.stdpath("cache") .. "/",
                -- (string) The filename format to use. Can include placeholders for date and time.
                -- https://time-rs.github.io/book/api/format-description.html#components
                -- format = "silicon.png"
                format = "silicon_[year][month][day]_[hour][minute][second].png"

            },
            -- Background and shadow configuration for the screenshot
            background = "#FFFFFF00", -- (string) The background color for the screenshot.
            shadow = {
                -- (number) The blur radius for the shadow, set to 0.0 for no shadow.
                blur_radius = 10.0,
                -- (number) The horizontal offset for the shadow.
                offset_x = 0,
                -- (number) The vertical offset for the shadow.
                offset_y = 0,
                -- (string) The color for the shadow.
                color = "#0000007F"
            },

            -- (number) The horizontal padding.
            pad_horiz = 50,
            -- (number) The vertical padding.
            pad_vert = 50,
            -- (boolean) Whether to show line numbers in the screenshot.
            line_number = true,
            -- (number) The padding between lines.
            line_pad = 0,
            -- (number) The starting line number for the screenshot.
            line_offset = 0,
            -- (number) The tab width for the screenshot.
            tab_width = 4,
            -- (boolean) Whether to trim extra indentation.
            gobble = false,
            -- (boolean) Whether to capture the whole file and highlight selected lines.
            highlight_selection = false,
            round_corner = true,
            -- (boolean) Whether to show window controls (minimize, maximize, close) in the screenshot.
            window_controls = false,
            window_title = function()
                return vim.fn.fnamemodify(vim.fn.bufname(vim.fn.bufnr()), ":~:.")
            end
        }
    }
}
