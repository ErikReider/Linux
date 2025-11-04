pcall(require, "snacks")

local indent_exlude = {
    "help",
    "terminal",
    "dashboard",
    "nerdtree",
    "lazy",
}

return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        enabled = true,
        lazy = false,
        opts =
            ---@type snacks.Config
            {
                bigfile = { enabled = true },
                notifier = { enabled = true },
                notify = { enabled = true },
                quickfile = { enabled = true },

                ---@type snacks.animate.Config
                animate = {
                    fps = 60,
                },
                styles = {
                    input = {
                        title = "Input:",
                        border = "rounded",
                        backdrop = 60,
                        height = 1,
                        width = 80,
                        min_width = 20,
                        wo = {
                            winblend = 10,
                            winhighlight = "",
                        },
                        ---@type (number|boolean|fun(self: snacks.win):number)?
                        row = false,
                        ---@type (number|boolean|fun(self: snacks.win):number)?
                        col = false,
                    },
                    lazygit = {
                        border = "rounded",
                    },
                    terminal = {
                        border = "rounded",
                        position = "float",
                    },
                },

                statuscolumn = {
                    enabled = true,
                    folds = {
                        open = true,
                        git_hl = true,
                    },
                },
                indent = {
                    enabled = true,
                    indent = {
                        char = "▏",
                    },
                    scope = {
                        char = "▏",
                        hl = {
                            "RainbowDelimiterRed",
                            "RainbowDelimiterYellow",
                            "RainbowDelimiterBlue",
                            "RainbowDelimiterOrange",
                            "RainbowDelimiterGreen",
                            "RainbowDelimiterViolet",
                            "RainbowDelimiterCyan",
                        },
                    },
                    -- filter for buffers to enable indent guides
                    ---@param buf number
                    ---@param win number
                    filter = function(buf, win)
                        local b = vim.bo[buf]
                        for _, value in pairs(indent_exlude) do
                            if b.filetype == value or b.buftype == value then
                                return false
                            end
                        end
                        return true
                    end,
                },

                input = { enabled = true },
                picker = {
                    enabled = true,
                    ui_select = true,
                    layout = {
                        layout = {},
                    },
                    layouts = {
                        select = {
                            hidden = { "preview" },
                            layout = {
                                backdrop = 60,
                                width = -1,
                                max_width = 140,
                                min_width = 40,
                                height = -1,
                                min_height = 10,
                                box = "vertical",

                                ---@type (number|boolean|fun(self: snacks.win):number)?
                                row = false,
                                ---@type (number|boolean|fun(self: snacks.win):number)?
                                col = false,

                                border = "rounded",
                                title = "{title}",
                                title_pos = "center",

                                {
                                    win = "input",
                                    height = 1,
                                    border = "bottom",
                                    wo = {
                                        winblend = 10,
                                        winhighlight = "",
                                    },
                                },
                                {
                                    win = "list",
                                    border = "none",
                                    wo = {
                                        winblend = 10,
                                        winhighlight = "",
                                    },
                                },
                                {
                                    win = "preview",
                                    title = "{preview}",
                                    height = 0.4,
                                    border = "top",
                                    wo = {
                                        winblend = 10,
                                        winhighlight = "",
                                    },
                                },
                            },
                        },
                    },
                    win = {
                        input = {
                            keys = {
                                ["<Esc>"] = { "close", mode = { "n", "i" } },
                            },
                        },
                    },
                },
            },
    },
}
