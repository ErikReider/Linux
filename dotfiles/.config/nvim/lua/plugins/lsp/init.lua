-- NeoVim LSP
return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            vim.lsp.log.set_level(vim.log.levels.WARN)
            -- For debugging:
            -- vim.lsp.log.set_level(vim.log.levels.DEBUG)

            vim.diagnostic.config({
                -- Gutter diagnostic signs
                signs = {
                    text = {
                        -- [vim.diagnostic.severity.ERROR] = "❌",
                        [vim.diagnostic.severity.ERROR] = "",
                        -- [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        -- [vim.diagnostic.severity.HINT] = "💡",
                        [vim.diagnostic.severity.HINT] = "",
                        -- [vim.diagnostic.severity.INFO] = "",
                        [vim.diagnostic.severity.INFO] = "",
                    },
                    numhl = {
                        [vim.diagnostic.severity.ERROR] = "DiagnosticLineNrError",
                        [vim.diagnostic.severity.WARN] = "DiagnosticLineNrWarn",
                        [vim.diagnostic.severity.HINT] = "DiagnosticLineNrHint",
                        [vim.diagnostic.severity.INFO] = "DiagnosticLineNrInfo",
                    },
                },
                -- disable virtual text
                virtual_text = false,
                update_in_insert = true,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = true,
                    style = "minimal",
                    border = "rounded",
                    source = true,
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
            {
                "akinsho/flutter-tools.nvim",
                lazy = false,
                dependencies = {
                    'nvim-lua/plenary.nvim',
                    'stevearc/dressing.nvim', -- optional for vim.ui.select
                },
                config = true,
            },
            -- 🦀 Supercharge your Rust experience in Neovim! A heavily modified fork of rust-tools.nvim
            -- rust-tools.nvim replacement
            {
                "mrcjkb/rustaceanvim",
                version = '^6', -- Recommended
                lazy = false, -- This plugin is already lazy
            },
            -- Java eclipse tools
            "mfussenegger/nvim-jdtls",
            -- Clang tools
            "Civitasv/cmake-tools.nvim",

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
                    -- nvim-cmp source for vim's cmdline
                    "hrsh7th/cmp-cmdline",
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
                                               (vim.api.nvim_get_option_value("buftype", { buf = 0 }) ==
                                                   "prompt")
                                disabled = disabled or (vim.fn.reg_recording() ~= "")
                                disabled = disabled or (vim.fn.reg_executing() ~= "")
                                disabled = disabled or context.in_treesitter_capture("comment") or
                                               context.in_syntax_group("Comment")
                                return not disabled
                            end
                        end,
                        window = {
                            completion = cmp.config.window.bordered(),
                            documentation = cmp.config.window.bordered(),
                        },
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
                                if luasnip.get_active_snip() ~= nil then
                                    luasnip.unlink_current()
                                end
                                fallback()
                            end, { "i", "s" })
                        }),
                        sources = {
                            { name = "nvim_lsp" },
                            { name = "luasnip" },
                            { name = "path" },
                            { name = "buffer", option = { keyword_pattern = [[\k\+]] } }
                        }
                    })

                    -- Completions for / search based on current buffer:
                    -- `/` cmdline setup.
                    cmp.setup.cmdline("/", {
                        mapping = cmp.mapping.preset.cmdline(),
                        sources = { { name = "buffer" } }
                    })

                    -- Completions for command mode:
                    -- `:` cmdline setup.
                    cmp.setup.cmdline(":", {
                        mapping = cmp.mapping.preset.cmdline(),
                        sources = cmp.config.sources({ { name = "path" } }, {
                            { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } }
                        })
                    })
                end
            },

            --
            -- Lua Snip
            --
            -- Snippet Engine for Neovim written in Lua.
            {
                "L3MON4D3/LuaSnip",
                build = "make install_jsregexp",
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
                        filetypes_denylist = { "dirvish", "fugitive", "TelescopePrompt" },
                    })
                end
            },
            -- See LSP server startup status
            {
                "j-hui/fidget.nvim",
                opts = {
                    -- Options related to notification subsystem
                    notification = {
                        -- Options related to the notification window and buffer
                        window = {
                            avoid = { "NvimTree" } -- Filetypes the notification window should avoid
                        },
                    }
                }
            },

            --
            -- Lsp Installer
            --
            -- Auto installs lsps
            {
                "WhoIsSethDaniel/mason-tool-installer.nvim",
                lazy = false,
                dependencies = { { "williamboman/mason.nvim", opts = {} } },
                opts = require("plugins.lsp.mason_installer")
            },
            -- Auto installs DAP debuggers
            {
                "jay-babu/mason-nvim-dap.nvim",
                dependencies = {
                    -- Debug Adapter Protocol client implementation for Neovim
                    "mfussenegger/nvim-dap",
                    {
                        "rcarriga/nvim-dap-ui",
                        config = function() require("plugins.lsp.dapui") end,
                        dependencies = { "nvim-neotest/nvim-nio" }
                    },
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
            },
            {
                'creativenull/efmls-configs-nvim',
                version = 'v1.x.x', -- version is optional, but recommended
                dependencies = { 'neovim/nvim-lspconfig' },
            }
        }
    }
}
