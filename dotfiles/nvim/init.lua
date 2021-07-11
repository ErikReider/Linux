vim.cmd("luafile ~/.config/nvim/lua/functions.lua")

-- Init Plug
vim.cmd("source ~/.config/nvim/lua/plug.vim")

-- NeoVim general settings
vim.cmd("luafile ~/.config/nvim/lua/general.lua")
vim.cmd("source ~/.config/nvim/lua/autoLoad.vim")
vim.cmd("source ~/.config/nvim/lua/setFiletype.vim")
vim.cmd("source ~/.config/nvim/lua/vimEnter.vim")
vim.cmd("luafile ~/.config/nvim/lua/theme.lua")

-- Coc
vim.cmd("source ~/.config/nvim/lua/plugged/coc/coc.vim")

-- Plug configs
iterDir("~/.config/nvim/lua/plugged/*.vim",
        function(filename) vim.cmd("source " .. filename) end)

-- Source all .lua files
iterDir("~/.config/nvim/lua/plugged/*.lua",
        function(filename) vim.cmd("luafile " .. filename) end)

-- Other NeoVim settings
vim.cmd("luafile ~/.config/nvim/lua/mappings.lua")
