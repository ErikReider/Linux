vim.g.indent_blankline_char = "▏"

-- Indent indicators
local exclude = { "help", "terminal", "dashboard", "nerdtree", "lazy" }
return {
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            filetype_exclude = exclude,
            buftype_exclude = exclude,
            space_char_blankline = " ",
            show_current_context = true,
            use_treesitter = true,
            show_first_indent_level = false,
            context_patterns = { "class", "function", "method", "^if", "^for" }
        }

    }
}
