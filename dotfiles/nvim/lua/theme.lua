vim.cmd("colorscheme codedark")
vim.api.nvim_set_var("airline_theme", 'codedark')

-- Highlights yanked region
vim.cmd[[au TextYankPost * silent! lua vim.highlight.on_yank()]]

-- Shows space and tab as characters
vim.o.showbreak = "↪ "
vim.o.list = true
vim.o.listchars = "space:·,tab:⟶ ,nbsp:␣,trail:·,extends:⟩,precedes:⟨"
vim.highlight.create("SpecialKey", {ctermfg = "darkgray", guifg = "darkgray"},
                     false)
vim.highlight.create("NonText", {ctermfg = "darkgray", guifg = "darkgray"},
                     false)
vim.highlight.create("Whitespace", {ctermfg = "darkgray", guifg = "darkgray"},
                     false)

vim.highlight.create("LspReferenceText", {
    ctermbg = "darkgray",
    guibg = "darkgray",
    ctermfg = "white",
    guifg = "white",
    cterm="bold",
    gui="bold"
}, false)
vim.highlight.create("LspReferenceRead", {
    ctermbg = "darkgray",
    guibg = "darkgray",
    ctermfg = "white",
    guifg = "white",
    cterm="bold",
    gui="bold"
}, false)
vim.highlight.create("LspReferenceWrite", {
    ctermbg = "darkgray",
    guibg = "darkgray",
    ctermfg = "white",
    guifg = "white",
    cterm="bold",
    gui="bold"
}, false)

-- vim.cmd[[
-- highlight LspDiagnosticsUnderlineError guifg=NONE guibg=NONE guisp=#fb4934 gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl
-- highlight LspDiagnosticsUnderlineWarning guifg=NONE guibg=NONE guisp=#fabd2f gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl
-- highlight LspDiagnosticsUnderlineInfo guifg=NONE guibg=NONE guisp=#83a598 gui=undercurl ctermfg=NONE ctermbg=NONE cterm=undercurl
-- ]]
