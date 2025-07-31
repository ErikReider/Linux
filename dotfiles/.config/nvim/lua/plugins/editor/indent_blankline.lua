-- Indent indicator
local exclude = { "help", "terminal", "dashboard", "nerdtree", "lazy" }
local highlight = {
    -- Don't highlight the first indent
    "IblIndent",
    -- default color values from the rainbow-delimiters.nvim README
    "RainbowDelimiterRed",
    "RainbowDelimiterYellow",
    "RainbowDelimiterBlue",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
    "RainbowDelimiterViolet",
    "RainbowDelimiterCyan",
}

return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        version = "v3.*", -- Latest stable version
        enabled = true,
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("ibl").setup({
                indent = {
                    char = "▏",
                    -- char = "▎",
                    smart_indent_cap = false,
                    tab_char = "⟶",
                },
                whitespace = { remove_blankline_trail = true },
                exclude = { filetypes = exclude, buftypes = exclude },
                scope = {
                    show_start = false,
                    show_end = false,
                    include = { node_type = { ["*"] = { "class", "function", "method", "^if", "^for" } } },
                    highlight = highlight,
                },
            })

            local hooks = require("ibl.hooks")
            local indent = require("ibl.indent")

            -- Setup rainbow delimiters
            hooks.register(hooks.type.SCOPE_HIGHLIGHT, function(tick, bufnr, scope, scope_index)
                -- Skip the first indent
                if scope_index == 1 then return 1 end
                return hooks.builtin.scope_highlight_from_extmark(tick, bufnr, scope, scope_index)
            end)

            -- Skip empty lines
            hooks.register(hooks.type.SKIP_LINE,
                           function(_, _, _, line) return (line == nil or line == "") end)
            -- Only draw tab on the first indent
            hooks.register(hooks.type.WHITESPACE, function(_, _, _, whitespace_tbl)
                -- Return early if not a tab char
                if not (whitespace_tbl[1] == indent.whitespace.TAB_START or whitespace_tbl[1] ==
                    indent.whitespace.TAB_START_SINGLE) then return whitespace_tbl end

                -- Skip the first line and check if any other chars are tab start characters
                for i = 2, #whitespace_tbl, 1 do
                    if whitespace_tbl[i] == indent.whitespace.TAB_START or whitespace_tbl[i] ==
                        indent.whitespace.TAB_START_SINGLE then
                        whitespace_tbl[i] = indent.whitespace.INDENT
                    end
                end
                return whitespace_tbl
            end)
        end,
    },
}
