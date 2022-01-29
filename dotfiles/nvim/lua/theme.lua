-- Colors: https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
vim.cmd("colorscheme codedark")
vim.api.nvim_set_var("airline_theme", 'codedark')

vim.o.termguicolors = true

-- Highlights yanked region
vim.cmd [[
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=1000})
augroup END
]]

-- Shows space and tab as characters
vim.opt.showbreak = "↪ "
vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("tab:⟶ ")
vim.opt.listchars:append("nbsp:␣")
vim.opt.listchars:append("trail:·")
vim.opt.listchars:append("extends:⟩")
vim.opt.listchars:append("precedes:⟨")

for _, v in ipairs({"SpecialKey", "NonText", "Whitespace"}) do
    vim.highlight.create(v, {ctermfg = "240", guifg = "#585858"}, false)
end

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
