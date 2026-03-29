local utils = require("utils")

--
-- Language specific plugins
--
return {
    -- Vim commands for Flutter, including hot-reload-on-save and more.
    {
        "akinsho/flutter-tools.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            ui = { border = vim.o.winborder },
            closing_tags = {
                highlight = "Comment", -- highlight for the closing tag
                prefix = "❯ ", -- character to use for close tag e.g. > Widget
                enabled = true, -- set to false to disable
            },
            lsp = {
                on_attach = function()
                    local commands = require("flutter-tools.commands")
                    -- Hot-reload on save
                    vim.api.nvim_create_autocmd("BufWritePost", {
                        group = vim.api.nvim_create_augroup("hotReload", { clear = true }),
                        pattern = "*.dart",
                        callback = function()
                            if not commands.is_running() then
                                vim.fn.execute([[!kill -SIGUSR1 $(pgrep -f "[f]lutter_tool.*run")]])
                            end
                        end,
                    })
                    -- Format on save
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = "hotReload",
                        pattern = "*.dart",
                        callback = function()
                            vim.lsp.buf.format({ async = true })
                        end,
                    })
                end,
                capabilities = utils.get_lsp_capabilities(),
            },
        },
    },
    -- 🦀 Supercharge your Rust experience in Neovim! A heavily modified fork of rust-tools.nvim
    -- rust-tools.nvim replacement
    {
        "mrcjkb/rustaceanvim",
        version = "^6", -- Recommended
        lazy = false, -- This plugin is already lazy
    },
    -- Faster LuaLS setup for Neovim
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        ---@alias lazydev.Library {path:string, words:string[], mods:string[]}
        ---@alias lazydev.Library.spec string|{path:string, words?:string[], mods?:string[]}
        ---@class lazydev.Config
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                -- Plugins
                -- { path = vim.fn.stdpath("data") .. "/lazy" },
            },
        },
    },
    -- Java eclipse tools
    "https://codeberg.org/mfussenegger/nvim-jdtls",
    -- CMake tools
    "Civitasv/cmake-tools.nvim",
    -- Clangd Protocol extensions support
    {
        url = "https://git.sr.ht/~p00f/clangd_extensions.nvim",
        lazy = false,
    },
}
