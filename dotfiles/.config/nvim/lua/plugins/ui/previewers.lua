---@module "lazy"

-- File preview
---@type LazySpec
return {
    -- Markdown preview
    {
        "toppair/peek.nvim",
        build = "deno task --quiet build:fast",
        ft = "markdown",
        config = function()
            local peek = require("peek")

            peek.setup({
                auto_load = false, -- whether to automatically load preview when
                -- entering another markdown buffer
                close_on_bdelete = true, -- close preview window on buffer delete
                syntax = true, -- enable syntax highlighting, affects performance
                theme = "dark", -- "dark" or "light"
                update_on_change = true,
                -- relevant if update_on_change is true
                throttle_at = 200000, -- start throttling when file exceeds this
                -- amount of bytes in size
                throttle_time = "auto", -- minimum amount of time in milliseconds
                -- that has to pass before starting new render
            })

            vim.api.nvim_create_user_command("PeekOpen", peek.open, {})
            vim.api.nvim_create_user_command("PeekClose", peek.close, {})
            vim.api.nvim_create_user_command("PeekOpenOrClose", function()
                if peek.is_open() then
                    peek.close()
                else
                    peek.open()
                end
            end, {})
        end,
    },
    -- HTML
    {
        "turbio/bracey.vim",
        build = "npm install --prefix server",
        ft = "html",
        config = function()
            vim.g.bracey_server_path = "http://localhost"
            vim.g.bracey_refresh_on_save = 1
        end,
    },
    {
        "aurum77/live-server.nvim",
        cmd = { "LiveServer", "LiveServerStart", "LiveServerStop", "LiveServerInstall" },
        build = function()
            require("live_server.util").install()
        end,
    },
    -- Latex: Forward and Inverse Search for Texlab and neovim
    {
        "f3fora/nvim-texlabconfig",
        ft = require("filetypes")["latex"],
        build = {
            "go build",
            -- Install evince synctex through pip3
            "pip3 install --target=. https://github.com/efoerster/evince-synctex/archive/master.zip",
        },
        main = "texlabconfig",
        init = function(plugin)
            local utils = require("utils")
            utils.prepend_plugin_to_PATH(plugin)
            utils.prepend_plugin_to_PATH(plugin, "bin")
            utils.prepend_plugin_to_PYTHONPATH(plugin)
        end,
    },
}
