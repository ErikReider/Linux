require("utils")

-- Add ~/.config/nvim/bin to PATH
_G.add_to_env_path({ vim.fn.stdpath("config"), "bin" })

-- NeoVim general settings
require("general")
require("filetypes")
require("neovide")
require("mappings")
require("autoLoad")

-- Init Plug
require("lazy-nvim")
