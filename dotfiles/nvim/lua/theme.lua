vim.o.termguicolors = true

-- Colors: https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
-- Colors2: https://www.ditig.com/256-colors-cheat-sheet

-- Enable italic comment
vim.g.vscode_italic_comment = 1
-- Gets called when the GTK color-scheme changes
require("custom.gsettings_watcher").init(function(style)
    vim.g.gtk_style = style
    vim.o.background = style
    vim.g.vscode_style = style
    vim.cmd([[colorscheme vscode]])
end)

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

-- Word highlight
vim.api.nvim_set_hl(0, "illuminate", {link = "LspReferenceText"})
vim.api.nvim_set_hl(0, "illuminatedWord", {link = "LspReferenceText"})
for _, v in
    ipairs({"LspReferenceText", "LspReferenceRead", "LspReferenceWrite"}) do
    vim.highlight.create(v, {cterm = "bold", gui = "bold"}, false)
end

-- Underlines
vim.highlight.create("DiagnosticUnderlineError",
                     {gui = "undercurl", cterm = "undercurl"})
vim.highlight.create("DiagnosticUnderlineWarn",
                     {gui = "undercurl", cterm = "undercurl"})
vim.highlight.create("DiagnosticUnderlineInfo",
                     {gui = "undercurl", cterm = "undercurl"})

-- Nvim-tree fixes
vim.api.nvim_set_hl(0, "NvimTreeGitIgnored", {link = "NvimTreeEmptyFolderName"})
vim.highlight.create("NvimTreeGitNew", {guifg = "#73c991"})
