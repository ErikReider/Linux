return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- Locked to commit due to Dart lag, https://github.com/nvim-treesitter/nvim-treesitter/issues/4945
    -- commit = "33eb472",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        -- Syntax aware text-objects, select, move, swap, and peek support
        "nvim-treesitter/nvim-treesitter-textobjects",
        -- Sets commentstring for JS/TS files
        {
            "JoosepAlviste/nvim-ts-context-commentstring",
            -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
            main = "ts_context_commentstring",
            opts = function()
                local c_comment_string = { __default = "// %s", __multiline = "// %s" }
                return {
                    enable = true,
                    enable_autocmd = false,
                    languages = {
                        -- css = c_comment_string,
                        -- scss = c_comment_string,
                        c = c_comment_string,
                        cpp = c_comment_string,
                        vala = c_comment_string,
                        glsl = c_comment_string,
                        asm = { __default = "# %s", __multiline = "# %s" },
                    },
                };
            end,
        },
        -- Code context
        {
            "nvim-treesitter/nvim-treesitter-context",
            config = function()

                require("treesitter-context").setup({
                    -- Enable this plugin (Can be enabled/disabled later via commands)
                    enable = true,
                    -- How many lines the window should span. Values <= 0 mean no limit.
                    max_lines = 0,
                    -- Which context lines to discard if `max_lines` is exceeded. Choices: "inner", "outer"
                    trim_scope = "outer",
                    -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
                    patterns = {
                        default = { "class", "function", "method", "for", "while", "if", "switch", "case" },
                    },
                })
            end,
        },
        -- Rainbow delimiters for Neovim through Tree-sitter
        "HiPhish/rainbow-delimiters.nvim",
        -- Treesitter auto close tags
        "windwp/nvim-ts-autotag",
    },
    config = function()
        -- vim.cmd("set foldmethod=expr")
        -- vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")

        -- Skip backwards compatibility routines and speed up loading.
        vim.g.skip_ts_context_commentstring_module = true

        require("nvim-treesitter.configs").setup({
            ensure_installed = "all",
            highlight = { enable = true, additional_vim_regex_highlighting = false },
            rainbow = {
                enable = true,
                -- list of languages you want to disable the plugin for
                disable = {},
                -- Which query to use for finding delimiters
                query = "rainbow-parens",
                -- Highlight the entire buffer all at once: TODO: Change this to local?
                strategy = require("rainbow-delimiters").strategy.global,
            },
            autotag = {
                enable = true,
                enable_rename = true,
                enable_close = true,
                enable_close_on_slash = true,
                filetypes = {
                    "html",
                    "javascript",
                    "typescript",
                    "javascriptreact",
                    "typescriptreact",
                    "svelte",
                    "vue",
                    "tsx",
                    "jsx",
                    "rescript",
                    "xml",
                    "php",
                    "markdown",
                    "glimmer",
                    "handlebars",
                    "hbs",
                    "htmldjango",
                    "elixir",
                    "heex",
                    "blade",
                },
            },
            -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
            textobjects = {
                select = {
                    enable = true,

                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,

                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        -- You can optionally set descriptions to the mappings (used in the desc parameter of
                        -- nvim_buf_set_keymap) which plugins like which-key display
                        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                    },
                    -- You can choose the select mode (default is charwise 'v')
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * method: eg 'v' or 'o'
                    -- and should return the mode ('v', 'V', or '<c-v>') or a table
                    -- mapping query_strings to modes.
                    selection_modes = {
                        ["@parameter.outer"] = "v", -- charwise
                        ["@function.outer"] = "V", -- linewise
                        ["@class.outer"] = "<c-v>", -- blockwise
                    },
                    -- If you set this to `true` (default is `false`) then any textobject is
                    -- extended to include preceding or succeeding whitespace. Succeeding
                    -- whitespace has priority in order to act similarly to eg the built-in
                    -- `ap`.
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * selection_mode: eg 'v'
                    -- and should return true of false
                    include_surrounding_whitespace = true,
                },
            },
        })

        local parser_config = require"nvim-treesitter.parsers".get_parser_configs()
        parser_config.blade = {
            install_info = {
                url = "https://github.com/EmranMR/tree-sitter-blade",
                files = { "src/parser.c" },
                branch = "main",
            },
            filetype = "blade",
        }
    end,
}

