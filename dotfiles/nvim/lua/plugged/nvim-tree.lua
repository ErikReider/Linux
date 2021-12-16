vim.g.nvim_tree_git_hl = 1 -- 0 by default, will enable file highlight for git attributes (can be used without the icons).
vim.g.nvim_tree_highlight_opened_files = 1 -- 0 by default, will enable folder and file icon highlight for opened files/directories.
vim.g.nvim_tree_root_folder_modifier = ':~' -- This is the default. See :help filename-modifiers for more options
-- vim.g.nvim_tree_add_trailing = 1 -- 0 by default, append a trailing slash to folder names
vim.g.nvim_tree_group_empty = 1 -- 0 by default, compact folders that only contain a single folder into one node in the file tree
-- vim.g.nvim_tree_disable_window_picker = 1 -- 0 by default, will disable the window picker.
-- vim.g.nvim_tree_icon_padding = ' ' -- one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
-- vim.g.nvim_tree_symlink_arrow = ' >> ' -- defaults to ' ➛ '. used as a separator between symlinks' source and target.
-- vim.g.nvim_tree_respect_buf_cwd = 1 -- 0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
-- vim.g.nvim_tree_create_in_closed_folder = 0 -- 1 by default, When creating files, sets the path of a file when cursor is on a closed folder to the parent folder when 0, and inside the folder when 1.
vim.g.nvim_tree_icons = {
    default = '',
    symlink = '',
    git = {
        unstaged = "",
        staged = "✓",
        unmerged = "",
        renamed = "➜",
        untracked = "",
        deleted = "",
        ignored = "◌"
    },
    folder = {
        arrow_open = "",
        arrow_closed = "",
        default = "",
        open = "",
        empty = "",
        empty_open = "",
        symlink = "",
        symlink_open = ""
    }
}

require("nvim-tree").setup({
    -- disables netrw completely
    disable_netrw = true,
    -- hijack netrw window on startup
    hijack_netrw = true,
    -- open the tree when running this setup function
    open_on_setup = false,
    -- will not open on setup if the filetype is in this list
    ignore_ft_on_setup = {},
    -- closes neovim automatically when the tree is the last **WINDOW** in the view
    auto_close = false,
    -- opens the tree when changing/opening a new tab if the tree wasn't previously opened
    open_on_tab = false,
    -- hijack the cursor in the tree to put it at the start of the filename
    hijack_cursor = false,
    -- updates the root directory of the tree on `DirChanged` (when you run `:cd` usually)
    update_cwd = true,
    -- hijacks new directory buffers when they are opened.
    update_to_buf_dir = {
        enable = true,
        -- allow to open the tree if it was previously closed
        auto_open = true
    },
    -- show lsp diagnostics in the signcolumn
    diagnostics = {
        enable = true,
        icons = {hint = "💡", info = "", warning = "", error = "❌"}
    },
    -- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
    update_focused_file = {
        enable = false,
        -- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
        -- only relevant when `update_focused_file.enable` is true
        update_cwd = false,
        -- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
        -- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
        ignore_list = {'.git', 'node_modules', '.cache'}
    },
    -- configuration options for the system open command (`s` in the tree by default)
    system_open = {
        -- the command to run this, leaving nil should work in most cases
        cmd = nil,
        -- the command arguments as a list
        args = {}
    },
    filters = {
        -- do not show `dotfiles` (files starting with a `.`)
        dotfiles = false,
        -- Ignore these files / directories
        custom = {'.git', 'node_modules', '.cache'}
    },
    git = {enable = true, ignore = true, timeout = 500},
    view = {
        -- width of the window, can be either a number (columns) or a string in `%`, for left or right side placement
        width = 40,
        -- height of the window, can be either a number (columns) or a string in `%`, for top or bottom side placement
        height = 30,
        -- Hide the root path of the current folder on top of the tree
        hide_root_folder = false,
        -- side of the tree, can be one of 'left' | 'right' | 'top' | 'bottom'
        side = 'left',
        -- if true the tree will resize itself after opening a file
        auto_resize = false,
        mappings = {
            -- custom only false will merge the list with the default mappings
            -- if true, it will only use your list to set the mappings
            custom_only = false,
            -- list of mappings to set on the tree manually
            list = {}
        },
        number = false,
        relativenumber = false
    },
    trash = {cmd = "trash", require_confirm = true}
})

map('n', '<C-n>', ':NvimTreeToggle <CR>', {silent = true})
map('n', '<C-m>', ":NvimTreeFindFile <CR>", {silent = true})

