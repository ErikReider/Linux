return {
    -- Hydra
    {
        -- "anuvyklack/hydra.nvim",
        "nvimtools/hydra.nvim",
        dependencies = {
            {
                "mrjones2014/smart-splits.nvim",
                config = function()
                    -- TODO: Use tmux to gain per split tablines
                    require("smart-splits").setup({
                        -- Ignored filetypes (only while resizing)
                        ignored_filetypes = { "nofile", "quickfix", "prompt" },
                        -- Ignored buffer types (only while resizing)
                        ignored_buftypes = { "NvimTree" },
                        default_amount = 3,
                        at_edge = "wrap",
                        resize_mode = {
                            -- key to exit persistent resize mode
                            quit_key = "<C-c>",
                            -- keys to use for moving in resize mode
                            -- in order of left, down, up right
                            resize_keys = { "<left>", "<down>", "<up>", "<right>" },
                            -- set to true to silence the notifications
                            -- when entering/exiting persistent resize mode
                            silent = false,
                            -- must be functions, they will be executed when
                            -- entering or exiting the resize mode
                            hooks = { on_enter = nil, on_leave = nil },
                        },
                        -- ignore these autocmd events (via :h eventignore) while processing
                        -- smart-splits.nvim computations, which involve visiting different
                        -- buffers and windows. These events will be ignored during processing,
                        -- and un-ignored on completed. This only applies to resize events,
                        -- not cursor movement events.
                        ignored_events = { "BufEnter", "WinEnter" },
                        -- enable or disable the tmux integration
                        tmux_integration = false,
                        -- disable tmux navigation if current tmux pane is zoomed
                        disable_multiplexer_nav_when_zoomed = true,
                    })
                end,
            },
            "sindrets/winshift.nvim",
        },
        config = function()
            local Hydra = require("hydra")
            local splits = require("smart-splits")

            local cmd = require("hydra.keymap-util").cmd
            local pcmd = require("hydra.keymap-util").pcmd

            -- local buffer_hydra = Hydra({
            --     name = "Barbar",
            --     config = {
            --         on_key = function()
            --             -- Preserve animation
            --             vim.wait(200, function() vim.cmd "redraw" end, 30, false)
            --         end
            --     },
            --     heads = {
            --         {"h", function() vim.cmd("BufferPrevious") end, {on_key = false}},
            --         {
            --             "l", function() vim.cmd("BufferNext") end,
            --             {desc = "choose", on_key = false}
            --         }, {"H", function() vim.cmd("BufferMovePrevious") end},
            --         {"L", function() vim.cmd("BufferMoveNext") end, {desc = "move"}},
            --
            --         {"p", function() vim.cmd("BufferPin") end, {desc = "pin"}},
            --
            --         {"d", function() vim.cmd("BufferClose") end, {desc = "close"}},
            --         {"c", function() vim.cmd("BufferClose") end, {desc = false}},
            --         {"q", function() vim.cmd("BufferClose") end, {desc = false}}, {
            --             "od", function() vim.cmd("BufferOrderByDirectory") end,
            --             {desc = "by directory"}
            --         },
            --         {
            --             "ol", function() vim.cmd("BufferOrderByLanguage") end,
            --             {desc = "by language"}
            --         }, {"<Esc>", nil, {exit = true}}
            --     }
            -- })
            --
            -- local function choose_buffer()
            --     if #vim.fn.getbufinfo({buflisted = true}) > 1 then
            --         buffer_hydra:activate()
            --     end
            -- end
            --
            -- vim.keymap.set("n", "<Leader>r", choose_buffer)

            -- TODO: Switch to H,J,K,L
            local window_hint = [[
     ^^Move        ^^^^       Size       ^^^^         Split
 ^^------------    ^^^^    ----------    ^^^^    ---------------
    ^ _<Up>_       ^^       _<S-Up>_        ^^       _<C-Up>_         ^_x_: horizontally
_<Left>_  _<Right>_  _<S-Left>_  _<S-Right>_  _<C-Left>_  _<C-Right>_  _v_: vertically
    _<Down>_       ^^^     _<S-Down>_       ^^      _<C-Down>_        ^_c_: close
     ^focus      ^^^^^       window       ^^^      _=_: equalize      ^_o_: remain only
]]

            local window_hydra = Hydra({
                name = "Windows",
                hint = window_hint,
                config = {
                    invoke_on_body = true,
                    hint = {
                        float_opts = {
                            style = "minimal",
                            border = "rounded",
                            title = "Hydra",
                            title_pos = "center",
                            focusable = false,
                            noautocmd = true,
                        },
                        offset = 0,
                    },
                    color = "red",
                },
                mode = "n",
                body = "<C-e>",
                heads = {
                    { "<Left>", "<C-w>h" },
                    { "<Down>", "<C-w>j" },
                    { "<Up>", pcmd("wincmd k", "E11", "close") },
                    { "<Right>", "<C-w>l" },
                    { "<S-Left>", cmd("WinShift left") },
                    { "<S-Down>", cmd("WinShift down") },
                    { "<S-Up>", cmd("WinShift up") },
                    { "<S-Right>", cmd("WinShift right") },
                    {
                        "<C-Left>",
                        function()
                            splits.resize_left(2)
                        end,
                    },
                    {
                        "<C-Down>",
                        function()
                            splits.resize_down(2)
                        end,
                    },
                    {
                        "<C-Up>",
                        function()
                            splits.resize_up(2)
                        end,
                    },
                    {
                        "<C-Right>",
                        function()
                            splits.resize_right(2)
                        end,
                    },
                    { "=", "<C-w>=", { desc = "equalize" } },
                    { "x", pcmd("split", "E36") },
                    { "<C-s>", pcmd("split", "E36"), { desc = false } },
                    { "v", pcmd("vsplit", "E36") },
                    { "<C-v>", pcmd("vsplit", "E36"), { desc = false } },

                    { "o", "<C-w>o", { exit = true, desc = "remain only" } },
                    { "c", pcmd("close", "E444") },
                    { "<C-c>", pcmd("close", "E444"), { desc = false } },
                    { "<C-q>", pcmd("close", "E444"), { desc = false } },

                    { "w", "<C-w>w", { exit = true, desc = false } },
                    { "<C-w>", "<C-w>w", { exit = true, desc = false } },
                    { "<C-o>", "<C-w>o", { exit = true, desc = false } },
                    { "<Esc>", nil, { exit = true, desc = false } },
                    { "<C-c>", nil, { exit = true, desc = false } },
                    { "q", nil, { exit = true, desc = false } },
                },
            })
        end,
    },
}
