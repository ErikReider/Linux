return {
    -- A replacement for mksession with a better API.
    -- Also support restoring sessions
    {
        "stevearc/resession.nvim",
        lazy = false,
        config = function()
            local resession = require("resession")
            resession.setup({
                -- Periodically save the current session
                autosave = {
                    enabled = true,
                    interval = 60,
                    notify = false,
                },
            })

            -- Automatically save a session when you exit Neovim
            vim.api.nvim_create_autocmd("VimLeavePre", {
                callback = function()
                    -- Always save a special session named "last"
                    resession.save("last")
                end,
            })

            -- Create one session per directory
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    -- Only load the session if nvim was started with no args and without reading from stdin
                    if vim.fn.argc(-1) ~= 0 or vim.g.using_stdin then
                        return
                    end
                    -- Save these to a different directory, so our manual sessions don't get polluted
                    resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
                end,
                nested = true,
            })
            vim.api.nvim_create_autocmd("VimLeavePre", {
                callback = function()
                    resession.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
                end,
            })
            vim.api.nvim_create_autocmd("StdinReadPre", {
                callback = function()
                    -- Store this for later
                    vim.g.using_stdin = true
                end,
            })
        end,
    },

    -- Auto tabwidth and style detection
    "tpope/vim-sleuth",
    -- To save write-protected files
    {
        "lambdalisue/suda.vim",
        config = function()
            vim.g.suda_smart_edit = 0
        end,
    },
    -- Neovim plugin for toggling booleans, etc.
    {
        "nat-418/boole.nvim",
        opts = {
            mappings = { increment = "<C-a>", decrement = "<C-x>" },
            -- User defined loops
            additions = { { "Foo", "Bar" }, { "tic", "tac", "toe" } },
            allow_caps_additions = { { "enable", "disable" } },
        },
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
        build = function()
            require("live_server.util").install()
        end,
    },
}
