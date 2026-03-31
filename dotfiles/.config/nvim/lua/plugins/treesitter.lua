---@module "lazy"

local ts_load_priority = 50

---@type LazySpec
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = {
            "cargo install --locked tree-sitter-cli",
            ":TSUpdate",
        },
        lazy = false,
        priority = ts_load_priority,
        config = function()
            local treesitter = require("nvim-treesitter")
            treesitter.install("all")

            -- Automatically start treesitter for supported filetypes
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(args.match) or args.match
                    local installed = require("nvim-treesitter").get_installed("parsers")
                    if vim.tbl_contains(installed, lang) then
                        vim.treesitter.start(args.buf)
                    end
                end,
            })

            -- Add removed parsers (due to them geing on GitLab instead of on GitHub)
            vim.api.nvim_create_autocmd("User", {
                pattern = "TSUpdate",
                callback = function()
                    require("nvim-treesitter.parsers").blueprint = {
                        ---@diagnostic disable-next-line: missing-fields
                        install_info = {
                            path = vim.fn.stdpath("config") .. "/ts-parsers/tree-sitter-blueprint",
                            queries = "queries",
                        },
                        maintainers = { "@gabmus" },
                        tier = 2,
                    }
                end,
            })
        end,
    },
    {
        -- Syntax aware text-objects, select, move, swap, and peek support
        -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/main
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        lazy = false,
        priority = ts_load_priority + 1,
        main = "nvim-treesitter-textobjects",
    },
    {
        -- Sets commentstring for JS/TS files
        -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = false,
        priority = ts_load_priority + 1,
        main = "ts_context_commentstring",
        opts = function()
            local c_comment_string = { __default = "// %s", __multiline = "// %s" }
            return {
                enable = true,
                enable_autocmd = false,
                languages = {
                    c = c_comment_string,
                    cpp = c_comment_string,
                    vala = c_comment_string,
                    glsl = c_comment_string,
                    blueprint = c_comment_string,
                    asm = { __default = "# %s", __multiline = "# %s" },
                },
            }
        end,
    },
    {
        -- Code context
        -- https://github.com/nvim-treesitter/nvim-treesitter-context
        "nvim-treesitter/nvim-treesitter-context",
        lazy = false,
        priority = ts_load_priority + 1,
        main = "treesitter-context",
    },
    {
        -- Rainbow delimiters for Neovim through Tree-sitter
        -- https://gitlab.com/HiPhish/rainbow-delimiters.nvim
        "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
        lazy = false,
        priority = ts_load_priority + 1,
    },
    {
        -- Treesitter auto close tags
        -- https://github.com/windwp/nvim-ts-autotag
        "windwp/nvim-ts-autotag",
        lazy = false,
        priority = ts_load_priority + 1,
        main = "nvim-ts-autotag",
        opts = {
            aliases = {
                ["htmldjango"] = "html",
                ["elixir"] = "html",
                ["heex"] = "html",
                ["blade"] = "html",
            },
        },
    },
}
