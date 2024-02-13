return {
    {
        "Mofiqul/vscode.nvim",
        lazy = false,
        config = function()
            local vscode = require("vscode")

            vim.o.termguicolors = true

            -- Colors: https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
            -- Colors2: https://www.ditig.com/256-colors-cheat-sheet

            -- Gets called when the GTK color-scheme changes
            require("custom.gsettings_watcher").init(function(style)
                vim.g.gtk_style = style
                vim.o.background = style
                vim.g.vscode_style = style

                local colors = require("vscode.colors").get_colors()
                local isDark = vim.o.background == "dark"
                local lspRef = {
                    bg = isDark and colors.vscPopupHighlightGray or colors.vscPopupHighlightLightBlue,
                    bold = true
                }

                local lspInlayHint = {
                    bg = isDark and "#3d3d3d" or "#c6c6c6",
                    fg = isDark and "#ffffff" or "#333333"
                }

                vscode.setup({
                    transparent = false,
                    italic_comments = true,
                    disable_nvimtree_bg = false,
                    -- Override highlight groups (see ./lua/vscode/theme.lua)
                    group_overrides = {
                        -- this supports the same val table as vim.api.nvim_set_hl
                        -- use colors from this colorscheme by requiring vscode.colors!

                        -- LSP Reference word highlight
                        LspReferenceText = lspRef,
                        LspReferenceRead = lspRef,
                        LspReferenceWrite = lspRef,
                        IlluminatedWordText = { link = "LspReferenceText" },
                        IlluminatedWordRead = { link = "LspReferenceRead" },
                        IlluminatedWordWrite = { link = "LspReferenceWrite" },

                        -- LSP InlineHint
                        LspInlayHint = lspInlayHint,

                        -- Custom colorcolumn color
                        VirtColumn = { link = "LineNr" },
                        -- Make floating window title more visible
                        FloatTitle = { link = "Normal" },

                        -- TODO: Use vscode colors
                        ConflictMarkerBegin = { bg = "#2f7366", blend = 100 },
                        ConflictMarkerOurs = { bg = "#25403B" },
                        ConflictMarkerTheirs = { bg = "#25394B" },
                        ConflictMarkerEnd = { bg = "#2F628F" },
                        ConflictMarkerCommonAncestorsHunk = { bg = "#754a81" },

                        -- Line Number diagnostic highlights
                        DiagnosticLineNrError = { bg = "#51202A", fg = colors.vscRed, bold = true },
                        DiagnosticLineNrWarn = { bg = "#51412A", fg = colors.vscYellow, bold = true },
                        DiagnosticLineNrInfo = { bg = "#1E535D", fg = "#00FFFF", bold = true },
                        DiagnosticLineNrHint = { bg = "#1E205D", fg = "#0000FF", bold = true }
                    }
                })

                vscode.load()
            end)

            -- Highlights yanked region
            vim.api.nvim_create_augroup("highlight_yank", { clear = true })
            vim.api.nvim_create_autocmd("TextYankPost", {
                group = "highlight_yank",
                callback = function()
                    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 1000 })
                end
            })

            -- Shows space and tab as characters
            vim.opt.showbreak = "↪ "
            vim.opt.list = true
            vim.opt.listchars:append("space:·")
            vim.opt.listchars:append("tab:⟶ ")
            vim.opt.listchars:append("nbsp:␣")
            vim.opt.listchars:append("trail:·")
            vim.opt.listchars:append("extends:⟩")
            vim.opt.listchars:append("precedes:⟨")
            vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
        end
    },
    "folke/tokyonight.nvim"
}
