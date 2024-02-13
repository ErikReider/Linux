return {
    -- Neovim lua functions
    "nvim-lua/plenary.nvim",

    -- Auto tabwidth and style detection
    "tpope/vim-sleuth",
    -- .editorconfig support
    "gpanders/editorconfig.nvim",
    -- To save write-protected files
    { "lambdalisue/suda.vim", config = function() vim.g.suda_smart_edit = 0 end },
    -- Allows quickly switching between header and implementation files for C/C++ in Neovim.
    "jakemason/ouroboros",
    -- Neovim plugin for toggling booleans, etc.
    {
        "nat-418/boole.nvim",
        opts = {
            mappings = { increment = "<C-a>", decrement = "<C-x>" },
            -- User defined loops
            additions = { { "Foo", "Bar" }, { "tic", "tac", "toe" } },
            allow_caps_additions = { { "enable", "disable" } }
        }
    },

    -- Git commands in vim like`Git diff`
    "tpope/vim-fugitive",
    -- GBrowse to open current file in browser
    "tpope/vim-rhubarb",
    -- GV to open git log, gb to open in browser
    "junegunn/gv.vim",

    {
        "aurum77/live-server.nvim",
        cmd = { "LiveServer", "LiveServerStart", "LiveServerStop", "LiveServerInstall" },
        build = function() require("live_server.util").install() end
    }
}
