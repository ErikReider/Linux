-- NeoVim LSP
return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            -- Gutter diagnostic signs
            local signs = { Error = "❌", Warn = "", Hint = "💡", Info = "" }
            for type, _ in pairs(signs) do
                vim.fn.sign_define("DiagnosticSign" .. type, {
                    text = "",
                    texthl = "DiagnosticSign" .. type,
                    numhl = "DiagnosticLineNr" .. type
                })
            end

            -- Customizing how diagnostics and handlers are displayed
            local handler_win_config =
                { border = "rounded", focusable = true, max_width = 80, max_height = 30 }
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, handler_win_config)

            vim.lsp.handlers["textDocument/signatureHelp"] =
                vim.lsp.with(vim.lsp.handlers.signature_help, handler_win_config)

            vim.diagnostic.config({
                -- disable virtual text
                virtual_text = false,
                -- show signs
                signs = true,
                update_in_insert = true,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = ""
                }
            })

            -- Setup servers
            require("plugins.lsp.servers")
        end,
        dependencies = {
            --
            -- Server specific plugins
            --
            -- Vim commands for Flutter, including hot-reload-on-save and more.
            { "akinsho/flutter-tools.nvim", ft = "dart" },
            -- Tools for better development in rust using neovim"s builtin lsp
            "simrat39/rust-tools.nvim",

            --
            -- Nvim cmp
            --
            -- A completion engine plugin for neovim written in Lua. 
            {
                "hrsh7th/nvim-cmp",
                dependencies = {
                    -- nvim-cmp comparator function for completion items that start with one or more underlines
                    "lukas-reineke/cmp-under-comparator",
                    -- nvim-cmp source for neovim builtin LSP client
                    "hrsh7th/cmp-nvim-lsp",
                    -- nvim-cmp source for buffer words.
                    "hrsh7th/cmp-buffer",
                    -- nvim-cmp source for filesystem paths.
                    "hrsh7th/cmp-path",
                    -- luasnip completion source for nvim-cmp
                    "saadparwaiz1/cmp_luasnip"
                },
                opts = {
                    lsp_symbols = {
                        Text = "",
                        Method = "",
                        Function = "",
                        Constructor = "",
                        Field = "",
                        Variable = "",
                        Class = "",
                        Interface = "",
                        Module = "",
                        Property = "",
                        Unit = "",
                        Value = "",
                        Enum = "",
                        Keyword = "",
                        Snippet = "",
                        Color = "",
                        File = "",
                        Reference = "",
                        Folder = "",
                        EnumMember = "",
                        Constant = "",
                        Struct = "",
                        Event = "",
                        Operator = "",
                        TypeParameter = ""
                    }
                },
                config = function(plugin_opts)
                    -- Set completeopt to have a better completion experience
                    vim.o.completeopt = "menu,menuone,noinsert"

                    local cmp = require("cmp")
                    local luasnip = require("luasnip");
                    cmp.setup({
                        snippet = { expand = function(args)
                            luasnip.lsp_expand(args.body)
                        end },
                        enabled = function()
                            -- disable completion in comments
                            local context = require "cmp.config.context"
                            -- keep command mode completion enabled when cursor is in a comment
                            if vim.api.nvim_get_mode().mode == "c" then
                                return true
                            else
                                local disabled = false
                                disabled = disabled or
                                               (vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt")
                                disabled = disabled or (vim.fn.reg_recording() ~= "")
                                disabled = disabled or (vim.fn.reg_executing() ~= "")
                                disabled = disabled or context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")
                                return not disabled
                            end
                        end,
                        sorting = {
                            comparators = {
                                cmp.config.compare.offset,
                                cmp.config.compare.exact,
                                cmp.config.compare.score,
                                require("cmp-under-comparator").under,
                                cmp.config.compare.kind,
                                cmp.config.compare.sort_text,
                                cmp.config.compare.length,
                                cmp.config.compare.order
                            }
                        },
                        formatting = {
                            fields = { "kind", "abbr" },
                            format = function(_, vim_item)
                                -- Truncate text
                                local label = vim_item.abbr
                                local truncated_label = vim.fn.strcharpart(label, 0, 40)
                                if truncated_label ~= label then
                                    vim_item.abbr = truncated_label .. "…"
                                end

                                vim_item.kind = plugin_opts.opts.lsp_symbols[vim_item.kind] or ""
                                vim_item.menu = nil
                                return vim_item
                            end
                        },
                        preselect = cmp.PreselectMode.None,
                        completion = { completeopt = vim.o.completeopt },
                        mapping = cmp.mapping.preset.insert({
                            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                            ["<C-f>"] = cmp.mapping.scroll_docs(4),
                            ["<C-Space>"] = cmp.mapping(function(fallback)
                                if not cmp.visible() then
                                    cmp.complete()
                                elseif cmp.visible() then
                                    cmp.close()
                                else
                                    fallback()
                                end
                            end, { "i" }),
                            ["<CR>"] = cmp.mapping.confirm({
                                behavior = cmp.ConfirmBehavior.Insert,
                                select = true
                            }),
                            ["<Tab>"] = cmp.mapping(function(fallback)
                                if luasnip.expand_or_jumpable() then
                                    luasnip.jump(1)
                                else
                                    fallback()
                                end
                            end, { "i", "s" }),
                            ["<S-Tab>"] = cmp.mapping(function(fallback)
                                if luasnip.jumpable(-1) then
                                    luasnip.jump(-1)
                                else
                                    fallback()
                                end
                            end, { "i", "s" }),
                            ["<C-c>"] = cmp.mapping(function(fallback)
                                -- If inside a snippet
                                if (luasnip.jumpable(0)) then
                                    vim.api.nvim_feedkeys(
                                        vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "t", true)
                                end
                                cmp.close()
                                fallback()
                            end, { "i", "s" }),
                            ["<ESC>"] = cmp.mapping(function(fallback)
                                luasnip.unlink_current()
                                fallback()
                            end, { "i", "s" })
                        }),
                        sources = {
                            { name = "nvim_lsp" },
                            { name = "luasnip" },
                            { name = "path" },
                            { name = "buffer" }
                        }
                    })
                end
            },

            --
            -- Lua Snip
            --
            -- Snippet Engine for Neovim written in Lua.
            {
                "L3MON4D3/LuaSnip",
                dependencies = {
                    -- Set of preconfigured snippets for different languages
                    "rafamadriz/friendly-snippets"
                },
                config = function()
                    local luasnip = require("luasnip")
                    local util = require("luasnip.util.util")

                    luasnip.config.setup({
                        history = false,
                        parser_nested_assembler = function(_, snippet)
                            local select = function(snip, no_move)
                                snip.parent:enter_node(snip.indx)
                                -- upon deletion, extmarks of inner nodes should shift to end of
                                -- placeholder-text.
                                for _, node in ipairs(snip.nodes) do
                                    node:set_mark_rgrav(true, true)
                                end

                                -- SELECT all text inside the snippet.
                                if not no_move then
                                    vim.api.nvim_feedkeys(
                                        vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
                                    local pos_begin, pos_end = snip.mark:pos_begin_end()
                                    util.normal_move_on(pos_begin)
                                    vim.api.nvim_feedkeys(
                                        vim.api.nvim_replace_termcodes("v", true, false, true), "n", true)
                                    util.normal_move_before(pos_end)
                                    vim.api.nvim_feedkeys(
                                        vim.api.nvim_replace_termcodes("o<C-G>", true, false, true), "n", true)
                                end
                            end
                            function snippet:jump_into(dir, no_move)
                                if self.active then
                                    -- inside snippet, but not selected.
                                    if dir == 1 then
                                        self:input_leave()
                                        return self.next:jump_into(dir, no_move)
                                    else
                                        select(self, no_move)
                                        return self
                                    end
                                else
                                    -- jumping in from outside snippet.
                                    self:input_enter()
                                    if dir == 1 then
                                        select(self, no_move)
                                        return self
                                    else
                                        return self.inner_last:jump_into(dir, no_move)
                                    end
                                end
                            end
                            -- this is called only if the snippet is currently selected.
                            function snippet:jump_from(dir, no_move)
                                if dir == 1 then
                                    return self.inner_first:jump_into(dir, no_move)
                                else
                                    self:input_leave()
                                    return self.prev:jump_into(dir, no_move)
                                end
                            end
                            return snippet
                        end
                    })

                    luasnip.filetype_extend("javascriptreact", { "typescript", "javascript" })
                    luasnip.filetype_extend("typescriptreact", { "typescript", "javascript" })
                    luasnip.filetype_extend("dart", { "flutter" })

                    -- Lazy load custom snippets
                    require("luasnip/loaders/from_vscode").lazy_load()
                end
            },

            --
            -- Other
            --
            -- A super powerful autopair for Neovim
            {
                "windwp/nvim-autopairs",
                config = function()
                    require("nvim-autopairs").setup({ disable_filetype = { "TelescopePrompt" } })
                    -- Adds auto insertion of "()" in cmp
                    -- require("nvim-autopairs.completion.cmp").setup({
                    --     map_cr = true, --  map <CR> on insert mode
                    --     map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
                    --     auto_select = true, -- automatically select the first item
                    --     insert = false, -- use insert confirm behavior instead of replace
                    --     map_char = { -- modifies the function or method delimiter by filetypes
                    --         all = "(",
                    --         tex = "{"
                    --     }
                    -- })
                end
            },
            -- Shows function signature (parameters)
            {
                enabled = false,
                "ray-x/lsp_signature.nvim",
                opts = {
                    -- Diabled until "https://github.com/ray-x/lsp_signature.nvim/issues/94" is fixed
                    bind = true,
                    doc_lines = 0,
                    handler_opts = { border = "rounded" },
                    always_trigger = false,

                    floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

                    floating_window_above_cur_line = true,

                    floating_window_off_x = 0,
                    floating_window_off_y = 0,

                    fix_pos = false,
                    hint_enable = true,
                    hint_prefix = "",
                    hint_scheme = "Comment",
                    hi_parameter = "LspSignatureActiveParameter",
                    max_height = 10,
                    max_width = 80,

                    zindex = 200,

                    shadow_blend = 36,
                    shadow_guibg = "Black",
                    timer_interval = 200,
                    toggle_key = nil
                }
            },
            -- Vim plugin for automatically highlighting other uses of the word under the cursor.
            {
                "RRethy/vim-illuminate",
                config = function()
                    require("illuminate").configure({
                        -- providers: provider used to get references in the buffer, ordered by priority
                        providers = { "lsp", "treesitter", "regex" },
                        -- delay: delay in milliseconds
                        delay = 100,
                        -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
                        filetypes_denylist = { "dirvish", "fugitive", "TelescopePrompt" },
                        -- filetypes_allowlist: filetypes to illuminate, this is overriden by filetypes_denylist
                        filetypes_allowlist = {},
                        -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
                        modes_denylist = {},
                        -- modes_allowlist: modes to illuminate, this is overriden by modes_denylist
                        modes_allowlist = {},
                        -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
                        -- Only applies to the 'regex' provider
                        -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
                        providers_regex_syntax_denylist = {},
                        -- providers_regex_syntax_allowlist: syntax to illuminate, this is overriden by providers_regex_syntax_denylist
                        -- Only applies to the 'regex' provider
                        -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
                        providers_regex_syntax_allowlist = {},
                        -- under_cursor: whether or not to illuminate under the cursor
                        under_cursor = true
                    })
                end
            },
            -- See LSP server startup status
            { "j-hui/fidget.nvim", tag = "legacy", opts = {} },

            --
            -- Lsp Installer
            --
            -- Auto installs lsps
            {
                "WhoIsSethDaniel/mason-tool-installer.nvim",
                lazy = false,
                dependencies = { { "williamboman/mason.nvim", opts = {} } },
                opts = { -- a list of all tools you want to ensure are installed upon
                    -- start; they should be the names Mason uses for each tool
                    ensure_installed = {
                        -- LSPs
                        { "vala-language-server", version = "HEAD" },
                        "bash-language-server",
                        "shellcheck",
                        "efm",
                        "clangd",
                        "lua-language-server",
                        "vim-language-server",
                        -- TODO: Use rust-tools
                        "rust-analyzer",
                        "css-lsp",
                        "html-lsp",
                        "json-lsp",
                        "dockerfile-language-server",
                        "emmet-ls",
                        "elixir-ls",
                        "lemminx",
                        "typescript-language-server",
                        "stylelint-lsp",
                        "pyright",
                        "omnisharp",
                        "texlab",

                        -- Linters
                        -- TODO: Linters
                        "vint",
                        "markdownlint",
                        "eslint_d",
                        "cpplint",

                        -- Formatters
                        "luaformatter",
                        "autopep8",
                        "shfmt",
                        -- TODO: Prettierd Plugins https://github.com/fsouza/prettierd#additional-plugins
                        "prettierd",
                        "clang-format",
                        "latexindent",
                    },
                    auto_update = false
                }
            },
            -- Auto installs DAP debuggers
            {
                "jay-babu/mason-nvim-dap.nvim",
                dependencies = {
                    -- Debug Adapter Protocol client implementation for Neovim
                    "mfussenegger/nvim-dap",
                    { "rcarriga/nvim-dap-ui", config = function()
                        require("plugins.lsp.dapui")
                    end },
                    {
                        "Weissle/persistent-breakpoints.nvim",
                        config = function()

                            require("persistent-breakpoints").setup {
                                save_dir = vim.fn.stdpath("data") .. "/nvim_checkpoints",
                                -- when to load the breakpoints? "BufReadPost" is recommanded.
                                load_breakpoints_event = { "BufReadPost" },
                                -- record the performance of different function. run :lua require('persistent-breakpoints.api').print_perf_data() to see the result.
                                perf_record = false
                            }

                            vim.fn.sign_define("DapBreakpoint", {
                                text = "",
                                texthl = "DiagnosticSignError",
                                linehl = "",
                                numhl = ""
                            })
                            vim.fn.sign_define("DapBreakpointCondition",
                                               { text = "", texthl = "", linehl = "", numhl = "" })
                            vim.fn.sign_define("DapLogPoint",
                                               { text = "ﱴ", texthl = "", linehl = "", numhl = "" })
                            vim.fn.sign_define("DapStopped", {
                                text = "",
                                texthl = "DiagnosticSignInfo",
                                linehl = "DiagnosticUnderlineInfo",
                                numhl = "DiagnosticSignInfo"
                            })
                            vim.fn.sign_define("DapBreakpointRejected", {
                                text = "",
                                texthl = "DiagnosticSignHint",
                                linehl = "",
                                numhl = ""
                            })
                        end
                    }
                },
                config = function()
                    require("mason-nvim-dap").setup({
                        -- A list of adapters to install if they're not already installed.
                        -- This setting has no relation with the `automatic_installation` setting.
                        -- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
                        ensure_installed = { "cppdbg", "elixir" },

                        -- NOTE: this is left here for future porting in case needed
                        -- Whether adapters that are set up (via dap) should be automatically installed if they're not already installed.
                        -- This setting has no relation with the `ensure_installed` setting.
                        -- Can either be:
                        --   - false: Daps are not automatically installed.
                        --   - true: All adapters set up via dap are automatically installed.
                        --   - { exclude: string[] }: All adapters set up via mason-nvim-dap, except the ones provided in the list, are automatically installed.
                        --       Example: automatic_installation = { exclude = { "python", "delve" } }
                        automatic_installation = false,

                        -- Whether adapters that are installed in mason should be automatically set up in dap.
                        -- Removes the need to set up dap manually.
                        -- See mappings.adapters and mappings.configurations for settings.
                        -- Must invoke when set to true: `require 'mason-nvim-dap'.setup_handlers()`
                        -- Can either be:
                        -- 	- false: Dap is not automatically configured.
                        -- 	- true: Dap is automatically configured.
                        -- 	- {adapters: {ADAPTER: {}, }, configurations: {ADAPTER: {}, }}. Allows overriding default configuration.
                        automatic_setup = false
                    })

                    -- local configs = {
                    --     cppdbg = 
                    -- }
                    --
                    -- mason_dap.setup_handlers({
                    --     cppdbg = function(_source_name)  end
                    -- })
                end
            }

        }
    }
}
