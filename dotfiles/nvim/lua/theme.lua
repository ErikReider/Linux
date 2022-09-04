vim.o.termguicolors = true

-- Colors: https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
-- Colors2: https://www.ditig.com/256-colors-cheat-sheet

-- Gets called when the GTK color-scheme changes
require("custom.gsettings_watcher").init(function(style)
    vim.g.gtk_style = style
    vim.o.background = style
    vim.g.vscode_style = style
    vim.cmd([[colorscheme vscode]])

    local c = require("vscode.colors")
    local isDark = vim.o.background == 'dark'
    local lspRef = {
        bg = isDark and c.vscPopupHighlightGray or c.vscPopupHighlightLightBlue,
        bold = true
    }
    require("vscode").setup({
        transparent = false,
        italic_comments = true,
        disable_nvimtree_bg = false,
        -- Override highlight groups (see ./lua/vscode/theme.lua)
        group_overrides = {
            -- this supports the same val table as vim.api.nvim_set_hl
            -- use colors from this colorscheme by requiring vscode.colors!

            LspReferenceText = lspRef,
            LspReferenceRead = lspRef,
            LspReferenceWrite = lspRef
        }
    })
end)

-- Highlights yanked region
vim.api.nvim_create_augroup("highlight_yank", {clear = true})
vim.api.nvim_create_autocmd("TextYankPost", {
    group = "highlight_yank",
    callback = function()
        vim.highlight.on_yank({higroup = "IncSearch", timeout = 1000})
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
vim.api.nvim_set_hl(0, "IlluminatedWordText", {link = "LspReferenceText"})
vim.api.nvim_set_hl(0, "IlluminatedWordRead", {link = "LspReferenceRead"})
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", {link = "LspReferenceWrite"})
-- for _, v in
-- ipairs({"LspReferenceText", "LspReferenceRead", "LspReferenceWrite"}) do
-- vim.highlight.create(v, {cterm = "bold", gui = "bold"}, false)
-- end
