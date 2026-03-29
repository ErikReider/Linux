-- NeoVim general settings and defaults
require("general")
require("neovide")
require("filetypes")

-- Init Lazy
require("lazy-nvim").setup({
    { import = "plugins.essentials" },
    { import = "plugins" },
    { import = "plugins.ui" },
    { import = "plugins.editor" },
})

local constants = require("constants")
local utils = require("utils")

-- Add ~/.config/nvim/bin to PATH
utils.prepend_path_to_PATH(constants.dir_plugin_bin)

-- Plugin-centric configs
require("commands")
require("mappings")
require("autoLoad")
