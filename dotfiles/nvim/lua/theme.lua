vim.cmd("colorscheme codedark")
vim.api.nvim_set_var("airline_theme", 'codedark')

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
vim.highlight.create("CocHighlightText", {
    ctermbg = "darkgray",
    guibg = "darkgray",
    ctermfg = "white",
    guifg = "white"
}, false)
