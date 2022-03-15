-- Colors: https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
-- vim.cmd("colorscheme codedark")
vim.api.nvim_set_var("airline_theme", 'codedark')

-- For dark theme
vim.g.vscode_style = "dark"
-- Enable transparent background.
-- vim.g.vscode_transparent = 1
-- Enable italic comment
vim.g.vscode_italic_comment = 1
vim.cmd("colorscheme vscode")

vim.o.termguicolors = true

-- Highlights yanked region
vim.api.nvim_create_augroup("highlight_yank", {clear = true})
vim.api.nvim_create_autocmd("TextYankPost", {
    group = "highlight_yank",
    callback = function()
        vim.highlight.on_yank({higroup = 'IncSearch', timeout = 1000})
    end
})

-- Shows space and tab as characters
vim.opt.showbreak = "↪ "
vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("tab:⟶ ")
vim.opt.listchars:append("nbsp:␣")
vim.opt.listchars:append("trail:·")
vim.opt.listchars:append("extends:⟩")
vim.opt.listchars:append("precedes:⟨")

for _, v in ipairs({
    "SpecialKey", "NonText", "Whitespace", "IndentBlanklineChar",
    "IndentBlanklineSpaceChar", "IndentBlanklineSpaceCharBlankline"
}) do vim.highlight.create(v, {ctermfg = "239", guifg = "#4e4e4e"}, false) end

vim.highlight.create("IndentBlanklineContextChar",
                     {ctermfg = "249", guifg = "#b2b2b2"}, false)

-- Word highlight
vim.highlight.create("illuminate", {
    ctermbg = "238",
    guibg = "#444444",
    cterm = "bold",
    guisp = "#fabd2f",
    gui = "bold"
}, false)
for _, v in ipairs({
    "LspReferenceText", "LspReferenceRead", "LspReferenceWrite",
    "illuminatedWord"
}) do vim.highlight.link(v, "illuminate") end

vim.highlight.create("DiagnosticUnderlineError",
                     {gui = "undercurl", cterm = "undercurl"})
vim.highlight.create("DiagnosticUnderlineWarn",
                     {gui = "undercurl", cterm = "undercurl"})
vim.highlight.create("DiagnosticUnderlineInfo",
                     {gui = "undercurl", cterm = "undercurl"})
