-- Searching
local winblend = 20

local flex_options = {
    winblend = winblend,
    show_line = false,
    results_title = "",
    preview_title = "",
    prompt_prefix = "❯ ",
    selection_caret = "❯ ",
    no_ignore = true
}

local cursor_options = {
    winblend = winblend,
    theme = "cursor",
    show_line = false,
    results_title = false,
    preview_title = false
}

function _G.telescopeGFiles(local_dir)
    local opts = {
        use_git_root = not local_dir,
        prompt_title = "Git Files " .. (local_dir and "CWD" or "ROOT")
    }
    local ok = pcall(require("telescope.builtin").git_files, opts)
    if not ok then require("telescope.builtin").find_files() end
end

function _G.telescopeFindFiles(git_ignore)
    local opts = {
        hidden = true,
        no_ignore = not git_ignore,
        no_ignore_parent = not git_ignore,
        prompt_title = (git_ignore and "Git " or "") .. "Files"
    }
    require("telescope.builtin").find_files(opts)
end

local opts = { noremap = true, silent = true }

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && " ..
                    "cmake --build build --config Release && " .. "cmake --install build --prefix build"
            },
            "nvim-telescope/telescope-file-browser.nvim",
            { "nvim-telescope/telescope-dap.nvim", dependencies = { "mfussenegger/nvim-dap" } }
        },
        lazy = false,
        config = function()
            local actions = require("telescope.actions")
            local telescope = require("telescope")

            telescope.setup({
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case"
                    }
                },
                pickers = {
                    find_files = tableMerge(flex_options, {
                        find_command = { "rg", "--hidden", "--files", "--glob", "!.git/" }
                    }),
                    git_files = tableMerge(flex_options, {
                        use_git_root = true,
                        git_command = {
                            "git",
                            "ls-files",
                            "--exclude-standard",
                            "--cached",
                            "--deduplicate",
                            "-o",
                            "-m"
                        }
                    }),
                    live_grep = tableMerge(flex_options, {
                        vimgrep_arguments = {
                            "rg",
                            "--hidden",
                            "--glob",
                            "!.git/",
                            "--color=never",
                            "--no-heading",
                            "--with-filename",
                            "--line-number",
                            "--column",
                            "--smart-case"
                        }
                    }),
                    buffers = flex_options,
                    oldfiles = flex_options,
                    keymaps = flex_options,
                    highlights = flex_options,
                    lsp_workspace_diagnostics = flex_options,
                    lsp_references = flex_options,
                    lsp_code_actions = cursor_options
                },
                defaults = {
                    layout_strategy = "flex",
                    layout_config = {
                        height = 0.9,
                        width = 0.9,
                        flex = { flip_columns = 133, flip_lines = 50 },
                        horizontal = { mirror = false },
                        vertical = { mirror = false }
                    },
                    mappings = {
                        i = {
                            ["<C-h>"] = actions.which_key,
                            ["<esc>"] = actions.close,
                            ["<C-u>"] = false,
                            ["<Tab>"] = actions.select_tab,
                            ["<C-i>"] = actions.file_split,
                            ["<C-s>"] = actions.file_vsplit,
                            ["<C-Up>"] = actions.preview_scrolling_up,
                            ["<C-Down>"] = actions.preview_scrolling_down,
                            ["<PageUp>"] = actions.preview_scrolling_up,
                            ["<PageDown>"] = actions.preview_scrolling_down,
                            ["<S-Up>"] = function(nr)
                                for _ = 1, 5, 1 do
                                    actions.move_selection_previous(nr)
                                end
                            end,
                            ["<S-Down>"] = function(nr)
                                for _ = 1, 5, 1 do
                                    actions.move_selection_next(nr)
                                end
                            end
                        }
                    }
                }
            })

            telescope.load_extension("fzf")
            telescope.load_extension("dap")

            --
            -- Keymaps
            --

            -- Menus
            map("n", "<F5>", require("custom.optionsWindow").show, opts)
            map("n", "<F6>", function()
                showFloatingMenu({
                    { title = "LazyGit", action = "LazyGit" },
                    { title = "Git Hunk Highlight", action = "Gitsigns toggle_linehl" },
                    { title = "Git Toggle Deleted", action = "Gitsigns toggle_deleted" },
                    { title = "Git Diff", action = "Gitsigns diffthis" },
                    { title = "Git log", action = "GV" },
                    { title = "Open in browser", action = "GBrowse" }
                })
            end, opts)

            -- All CWD files (except gitignored)
            map("n", "<Leader>f", [[<cmd>lua telescopeFindFiles(true)<CR>]], opts)
            -- All CWD files
            map("n", "<Leader>F", [[<cmd>lua telescopeFindFiles(false)<CR>]], opts)
            -- Git files git-root
            map("n", "<Leader>G", [[<cmd>lua telescopeGFiles(false)<CR>]], opts)
            -- Git status files
            map("n", "<Leader>g", [[<cmd>lua require("telescope.builtin").git_status()<CR>]], opts)
            -- Search for string inside of all files in CWD
            map("n", "<Leader>s", [[<cmd>lua require("telescope.builtin").live_grep()<CR>]], opts)
            -- Search for string inside buffer
            map("n", "<Leader>S", [[<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>]],
                opts)
            -- Search for open buffers
            map("n", "<Leader>b", [[<cmd>lua require("telescope.builtin").buffers()<CR>]], opts)
            -- Lists previously open files
            map("n", "<Leader>h", [[<cmd>lua require("telescope.builtin").oldfiles()<CR>]], opts)
            -- Lists normal mode keymappings
            map("n", "<Leader>m", [[<cmd>lua require("telescope.builtin").keymaps()<CR>]], opts)
            map("n", "<Leader>t", [[<cmd>TodoTelescope<CR>]], opts)

            -- Search for DAP breakpoints
            map("n", "<Leader>B", [[<cmd>lua require("telescope").extensions.dap.list_breakpoints()<CR>]],
                opts)
        end
    }
}
