-- TODO: https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#use-terminal-image-viewer-to-preview-images
-- TODO: https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#fast-image-preview-on-terminal-with-caching-using-chafa

-- Searching
local winblend = 20

local cursor_options = {
    winblend = winblend,
    theme = "cursor",
    show_line = false,
    results_title = false,
    preview_title = false,
}

---@type LazySpec
return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install",
            },
            "nvim-telescope/telescope-file-browser.nvim",
            { "nvim-telescope/telescope-dap.nvim", dependencies = { "mfussenegger/nvim-dap" } },
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
                        case_mode = "smart_case",
                    },
                },
                pickers = {
                    find_files = {
                        find_command = {
                            "rg",
                            "--files",
                            "--glob",
                            "!.git/",
                        },
                    },
                    git_files = {
                        git_command = {
                            "git",
                            "ls-files",
                            "--exclude-standard",
                            "--cached",
                            "--deduplicate",
                            "-o",
                            "-m",
                        },
                    },
                    live_grep = {
                        vimgrep_arguments = {
                            "rg",
                            "--glob",
                            "!.git/",
                            "--color=never",
                            "--no-heading",
                            "--with-filename",
                            "--line-number",
                            "--column",
                            "--smart-case",
                        },
                    },
                    lsp_code_actions = cursor_options,
                },
                defaults = {
                    winblend = winblend,
                    show_line = false,
                    results_title = "",
                    preview_title = "",
                    prompt_prefix = "❯ ",
                    selection_caret = "❯ ",
                    no_ignore = false,
                    layout_strategy = "flex",
                    layout_config = {
                        height = 0.9,
                        width = 0.9,
                        flex = { flip_columns = 133, flip_lines = 50 },
                        horizontal = { mirror = false },
                        vertical = { mirror = false },
                    },
                    -- Picker defaults
                    hidden = true,
                    use_git_root = true,
                    show_untracked = true,

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
                            end,
                        },
                    },
                },
            })

            telescope.load_extension("fzf")
            telescope.load_extension("dap")
            telescope.load_extension("flutter")
        end,
    },
}
