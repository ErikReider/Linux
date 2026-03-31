---@module "lazy"

-- Tree
---@type LazySpec
return {
    {
        -- https://github.com/nvim-tree/nvim-tree.lua
        "kyazdani42/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        opts = {
            on_attach = function(bufnr)
                local tree_api = require("nvim-tree.api")

                local function opts(desc)
                    return {
                        desc = "nvim-tree: " .. desc,
                        buffer = bufnr,
                        remap = false,
                        silent = true,
                        nowait = true,
                    }
                end

                -- default mappings
                tree_api.map.on_attach.default(bufnr)

                -- custom mappings
                vim.keymap.set("n", "<C-Enter>", tree_api.tree.change_root_to_node, opts("CD"))
                vim.keymap.set("n", "?", tree_api.tree.toggle_help, opts("Help"))
            end,
            auto_reload_on_write = true,
            disable_netrw = false,
            hijack_cursor = false,
            hijack_netrw = true,
            hijack_unnamed_buffer_when_opening = false,
            open_on_tab = false,
            sort_by = "name",
            update_cwd = true,
            view = {
                width = { min = 30, max = 100 },
                side = "left",
                preserve_window_proportions = false,
                number = false,
                relativenumber = false,
                signcolumn = "no",
            },
            renderer = {
                add_trailing = true,
                group_empty = false,
                highlight_git = true,
                root_folder_modifier = ":~",
                indent_markers = { enable = false, icons = { corner = "└ ", edge = "│ ", none = "  " } },
                icons = {
                    webdev_colors = true,
                    git_placement = "after",
                    padding = " ",
                    symlink_arrow = " ➛ ",
                    show = { file = true, folder = true, folder_arrow = true, git = true },
                    glyphs = {
                        default = "",
                        symlink = "",
                        folder = {
                            arrow_closed = "",
                            arrow_open = "",
                            default = "",
                            open = "",
                            empty = "",
                            empty_open = "",
                            symlink = "",
                            symlink_open = "",
                        },
                        git = {
                            unstaged = "M",
                            staged = "✓",
                            unmerged = "",
                            renamed = "➜",
                            untracked = "★",
                            deleted = "",
                            ignored = "",
                        },
                    },
                },
                special_files = {
                    "Cargo.toml",
                    "meson.build",
                    "Makefile",
                    "README.md",
                    "readme.md",
                    ".gitignore",
                },
            },
            hijack_directories = { enable = true, auto_open = true },
            update_focused_file = { enable = false, update_cwd = false, ignore_list = {} },
            system_open = { cmd = "", args = {} },
            diagnostics = {
                enable = true,
                show_on_dirs = true,
                icons = { hint = "", info = "", warning = "", error = "" },
            },
            filters = { dotfiles = false, custom = {}, exclude = { "^.git$", "node_modules", ".cache" } },
            git = { enable = true, ignore = false, timeout = 400 },
            actions = {
                use_system_clipboard = true,
                change_dir = { enable = true, global = false, restrict_above_cwd = false },
                open_file = {
                    quit_on_open = false,
                    resize_window = false,
                    window_picker = {
                        enable = true,
                        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                        exclude = {
                            filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                            buftype = { "nofile", "terminal", "help" },
                        },
                    },
                },
            },
            trash = { cmd = "trash", require_confirm = true },
            log = {
                enable = false,
                truncate = false,
                types = {
                    all = false,
                    config = false,
                    copy_paste = false,
                    diagnostics = false,
                    git = false,
                    profile = false,
                },
            },
        },
    },
}
