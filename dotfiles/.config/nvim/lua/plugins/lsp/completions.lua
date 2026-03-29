---Used to get a string with the number of spaces to offset the label details from the label.
---@param max_width number
---@param text string
---@param detail string
---@return string
local function label_center_spaces(max_width, text, detail)
    -- Handle percentage of screen width
    if max_width < 1 and max_width > 0 then
        max_width = math.floor(max_width * vim.api.nvim_win_get_width(0))
    end

    local blank = max_width - vim.fn.strdisplaywidth(text) - vim.fn.strdisplaywidth(detail)
    if blank <= 1 then
        return " "
    end
    return string.rep(" ", blank)
end

---@class Highlights
---@field text string
---@field highlights blink.cmp.DrawHighlight[]
---
---@param ctx blink.cmp.DrawItemContext
---@return Highlights
local function get_ctx_highlights(ctx)
    local label = ctx.label

    ---@type blink.cmp.DrawHighlight[]
    local highlights = {}

    -- ~ indicator, but only for non-snippets as blink handles that
    local is_expandable = false
    if ctx.item and ctx.item.kind ~= require("blink.cmp.types").CompletionItemKind.Snippet then
        if #(ctx.item.additionalTextEdits or {}) > 0 then
            is_expandable = true
        elseif ctx.item.insertTextFormat == vim.lsp.protocol.InsertTextFormat.Snippet then
            is_expandable = true
        end
        if is_expandable then
            label = label .. ctx.self.snippet_indicator
        end
    end

    table.insert(highlights, {
        0,
        #label,
        group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
    })

    local spaces = ""
    local detail = ""
    if ctx.label_detail and ctx.label_detail ~= "" then
        detail = ctx.label_detail

        spaces = " "
        if ctx.self.components then
            local component_label = ctx.self.components.label
            if not component_label.width or component_label.width.fill then
                spaces = label_center_spaces(component_label.width.max, label, detail)
            end
        end

        local text_length = #label + #spaces
        table.insert(highlights, {
            text_length,
            text_length + #detail,
            group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpGhostText",
        })
    end

    return { text = label .. spaces .. detail, highlights = highlights }
end

---@type blink.cmp.SortFunction
local function lsp_sorter(a, b)
    ---@diagnostic disable-next-line: undefined-field
    if not a.lsp_score or not b.lsp_score then
        return
    end

    ---@diagnostic disable-next-line: undefined-field
    if a.lsp_score > b.lsp_score then
        return true
    ---@diagnostic disable-next-line: undefined-field
    elseif a.lsp_score < b.lsp_score then
        return false
    end
end

return {
    --
    -- Blink.cmp
    --
    -- Performant, batteries-included completion plugin for Neovim
    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        -- version = "1.*",
        build = "cargo build --release",

        ---@type blink.cmp.Config
        opts = {
            enabled = function()
                -- keep command mode completion enabled when cursor is recording, etc...
                if vim.api.nvim_get_mode().mode == "c" then
                    return true
                else
                    local disabled = false
                    disabled = disabled or (vim.bo.buftype == "prompt")
                    disabled = disabled or (vim.b.completion == false)
                    disabled = disabled or (vim.fn.reg_recording() ~= "")
                    disabled = disabled or (vim.fn.reg_executing() ~= "")
                    return not disabled
                end
            end,
            keymap = {
                preset = "enter",
                ["<C-Space>"] = { "show", "cancel" },
                ["<C-e>"] = { "show_documentation", "hide_documentation", "fallback" },
                ["<CR>"] = { "accept", "fallback" },

                ["<Tab>"] = { "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },

                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },

                ["<C-d>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },

                ["<C-c>"] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            require("luasnip").unlink_current()
                        end
                        cmp.cancel()
                    end,
                    "fallback",
                },
                ["<ESC>"] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            require("luasnip").unlink_current()
                        end
                    end,
                    "fallback",
                },
            },

            appearance = {
                kind_icons = {
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
                    TypeParameter = "",
                },
            },

            completion = {
                accept = {
                    auto_brackets = {
                        enabled = true,
                    },
                },
                list = {
                    selection = {
                        preselect = function()
                            local no_preselect_ft = { "markdown", unpack(require("filetypes")["latex"]) }
                            return not require("blink.cmp").snippet_active({ direction = 1 })
                                and not vim.tbl_contains(no_preselect_ft, vim.bo.filetype)
                        end,
                        auto_insert = false,
                    },
                },
                menu = {
                    max_height = 15,
                    auto_show = true,
                    border = vim.o.winborder,
                    draw = {
                        snippet_indicator = "~",
                        columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                width = { fill = true },
                                ellipsis = true,
                                text = function(ctx)
                                    return get_ctx_highlights(ctx).text
                                end,
                                highlight = function(ctx)
                                    local highlights = get_ctx_highlights(ctx).highlights

                                    -- characters matched on the label by the fuzzy matcher
                                    for _, idx in ipairs(ctx.label_matched_indices) do
                                        table.insert(
                                            highlights,
                                            { idx, idx + 1, group = "BlinkCmpLabelMatch" }
                                        )
                                    end
                                    return highlights
                                end,
                            },
                        },
                    },
                },

                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 500,
                    window = {
                        border = vim.o.winborder,
                    },
                },

                -- Displays a preview of the selected item on the current line
                ghost_text = { enabled = false },
            },

            -- default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, via `opts_extend`
            sources = {
                default = function()
                    -- Only use buffer source when in comment
                    local node = vim.treesitter.get_node()
                    if node then
                        if vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
                            return { "buffer" }
                        end
                    end
                    return { "lsp", "snippets", "path", "buffer" }
                end,
                per_filetype = {
                    lua = { inherit_defaults = true, "lazydev" },
                },
                providers = {
                    lsp = { fallbacks = {} },
                    buffer = {
                        -- Fixes buffer sometimes being higher priority than snippets
                        score_offset = -20
                    },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                },
            },

            snippets = {
                preset = "luasnip",
                expand = function(snippet)
                    require("luasnip").lsp_expand(snippet)
                end,
                active = function(filter)
                    if filter and filter.direction then
                        return require("luasnip").jumpable(filter.direction)
                    end
                    return require("luasnip").in_snippet()
                end,
                jump = function(direction)
                    return require("luasnip").jump(direction)
                end,
            },

            -- experimental signature help support
            signature = {
                enabled = true,
                window = {
                    show_documentation = true,
                    treesitter_highlighting = true,
                    border = vim.o.winborder,
                },
            },

            fuzzy = {
                implementation = "rust",
                sorts = function()
                    local default_sorts = { "score", "sort_text", "label" }
                    if vim.bo.filetype == "lua" then
                        -- Prioritize label sorting for Lua files
                        return { "score", "label" }
                    elseif not vim.tbl_contains(require("filetypes")["cpp"], vim.bo.filetype) then
                        -- Default sorting for other filetypes
                        return {
                            -- custom sort using clangd `.lsp_score` property
                            -- https://github.com/saghen/blink.cmp/issues/1778
                            lsp_sorter,
                            -- your other sorts, below are defaults
                            unpack(default_sorts),
                        }
                    else
                        -- Default sorting for other filetypes
                        return default_sorts
                    end
                end,
            },

            cmdline = {
                completion = {
                    list = {
                        selection = {
                            preselect = false,
                        },
                    },
                    menu = {
                        auto_show = false,
                    },
                },
                sources = function()
                    local cmdtype = vim.fn.getcmdtype()
                    if cmdtype == "/" or cmdtype == "?" then
                        return { "buffer" }
                    else
                        return { "cmdline", "path" }
                    end
                end,
                keymap = {
                    ["<C-Space>"] = { "show", "cancel" },
                    ["<CR>"] = { "accept", "fallback" },
                    ["<Up>"] = { "select_prev", "fallback" },
                    ["<Down>"] = { "select_next", "fallback" },
                    ["<C-p>"] = { "select_prev", "fallback" },
                    ["<C-n>"] = { "select_next", "fallback" },
                },
            },
        },
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
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local luasnip = require("luasnip")
            local luasnap_util = require("luasnip.util.util")

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
                                vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
                                "n",
                                true
                            )
                            local pos_begin, pos_end = snip.mark:pos_begin_end()
                            luasnap_util.normal_move_on(pos_begin)
                            vim.api.nvim_feedkeys(
                                vim.api.nvim_replace_termcodes("v", true, false, true),
                                "n",
                                true
                            )
                            luasnap_util.normal_move_before(pos_end)
                            vim.api.nvim_feedkeys(
                                vim.api.nvim_replace_termcodes("o<C-G>", true, false, true),
                                "n",
                                true
                            )
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
                end,
            })

            luasnip.filetype_extend("javascriptreact", { "typescript", "javascript" })
            luasnip.filetype_extend("typescriptreact", { "typescript", "javascript" })
            luasnip.filetype_extend("dart", { "flutter" })

            -- Lazy load custom snippets
            require("luasnip/loaders/from_vscode").lazy_load()
        end,
    },

    --
    -- Other
    --

    -- A super powerful autopair for Neovim
    {
        -- https://github.com/windwp/nvim-autopairs
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
}
