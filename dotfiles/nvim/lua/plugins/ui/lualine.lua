-- Status line
return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()

            require("lualine").setup {
                options = {
                    icons_enabled = true,
                    theme = "vscode",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = { "packer" },
                    always_divide_middle = true,
                    globalstatus = true
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { { "branch", icon = { "", align = "left" } }, "diff" },
                    lualine_c = {
                        {
                            "filename",
                            file_status = true,
                            path = 1,
                            symbols = {
                                modified = "[+]", -- Text to show when the file is modified.
                                readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
                                unnamed = "[No Name]" -- Text to show for unnamed buffers.
                            }
                        },
                        "filesize"
                    },
                    lualine_x = {
                        "encoding",
                        { "fileformat", symbols = { unix = "", dos = "", mac = "" } }
                    },
                    lualine_y = {
                        { _G.get_indentation_string, on_click = _G.show_indentation_popup },
                        "filetype"
                    },
                    lualine_z = {
                        "progress",
                        "location",
                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic", "coc" },
                            sections = { "error", "warn", "info", "hint" },
                            diagnostics_color = {
                                error = "DiagnosticError",
                                warn = "DiagnosticWarn",
                                info = "DiagnosticInfo",
                                hint = "DiagnosticHint"
                            },
                            symbols = { error = "E", warn = "W", info = "I", hint = "H" },
                            colored = true,
                            update_in_insert = false,
                            always_visible = false
                        }
                    }
                },
                -- tabline = {
                -- lualine_a = {
                -- {
                -- "tabs",
                -- mode = 2, -- Shows tab_nr + tab_name
                -- max_length = function() return vim.o.columns end
                -- }
                -- },
                -- },
                extensions = { "nvim-tree" }
            }
        end
    }
}
