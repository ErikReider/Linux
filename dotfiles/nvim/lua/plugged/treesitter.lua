vim.cmd('set foldmethod=expr')
vim.cmd('set foldexpr=nvim_treesitter#foldexpr()')

local status_ok, config = pcall(require, "nvim-treesitter.configs")
if not status_ok then return end

config.setup({
    ensure_installed = "maintained",
    highlight = {
        enable = true,
        disable = {"vala"},
        additional_vim_regex_highlighting = false
    },
    rainbow = {
        enable = true,
        extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
        max_file_lines = nil -- Do not enable for files with more than 1000 lines, int
    }
})
