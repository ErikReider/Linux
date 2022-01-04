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
for _, v in ipairs({
    "LspReferenceText", "LspReferenceRead", "LspReferenceWrite",
    "illuminatedWord"
}) do
    vim.highlight.create(v, {
        ctermbg = "238",
        guibg = "#444444",
        cterm = "bold",
        guisp = "#fabd2f",
        gui = "bold"
    }, false)
end

-- vim.cmd[[
-- highlight LspDiagnosticsUnderlineError guifg=NONE guibg=NONE guisp=#fb4934 gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl
-- highlight LspDiagnosticsUnderlineWarning guifg=NONE guibg=NONE guisp=#fabd2f gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl
-- highlight LspDiagnosticsUnderlineInfo guifg=NONE guibg=NONE guisp=#83a598 gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl
-- ]]
