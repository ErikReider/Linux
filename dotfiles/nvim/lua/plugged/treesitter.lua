-- vim.cmd("set foldmethod=expr")
-- vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
local status_ok, config = pcall(require, "nvim-treesitter.configs")
if not status_ok then return end

config.setup({
    ensure_installed = "all",
    highlight = {enable = true, additional_vim_regex_highlighting = false},
    rainbow = {
        enable = true,
        extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
        max_file_lines = nil -- Do not enable for files with more than 1000 lines, int
    },
    autotag = {
        enable = true,
        filetypes = {
            "html", "javascript", "typescript", "javascriptreact",
            "typescriptreact", "svelte", "vue", "tsx", "jsx", "rescript", "xml",
            "php", "markdown", "glimmer", "handlebars", "hbs", "heex"
        }
    },
    -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
    context_commentstring = {enable = true, enable_autocmd = false}
})

require("treesitter-context").setup({
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: "inner", "outer"
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        default = {
            "class", "function", "method", "for", "while", "if", "switch",
            "case"
        }
    }
})
