local lsp_opts = { noremap = true, silent = true }
local opts = { noremap = true, silent = true }

-- Duplicate line
map(
    "n",
    "<C-d>",
    ":exe 'set clipboard=\"\"' | exe 'normal yyp' | exe 'set clipboard=unnamedplus'<CR>",
    { silent = true }
)

-- Opens selected link in xdg default browser
-- https://vim.fandom.com/wiki/Open_a_web-browser_with_the_URL_in_the_current_line
map(
    "n",
    "gx",
    ":silent !xdg-open <C-R>=escape(\"<C-R><C-F>\", \"#?&;\\|%\")<CR> 2> /dev/null >&2 & disown<CR>",
    { silent = true }
)

-- open init.vim on F3 (split if buffer is selected)
map(
    "n",
    "<F3>",
    "expand('%') == '' ? ':e $MYVIMRC <cr>' : ':vsplit $MYVIMRC <cr>'",
    { silent = true, expr = true }
)
-- Source on F4
map("n", "<F4>", ":checktime <CR> :source $MYVIMRC | redraw! <CR> :Sleuth <CR>", { silent = true })

-- Use double ESC to clear highlights
map("n", "<Esc><Esc>", ":nohl<CR>", { silent = true })

-- Pasting without overriding clipboard!
map("x", "<Leader>p", "\"_dP", { noremap = true, silent = true })

-- Substitute word under cursor
map("n", "<Leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {})

-- Bufferline
local barbar_opts = { noremap = true, silent = true }
map("n", "<C-PageUp>", ":BufferPrevious<CR>", barbar_opts)
map("n", "<C-PageDown>", ":BufferNext<CR>", barbar_opts)
map("n", "<M-S-Left>", "<Cmd>BufferMovePrevious<CR>", {})
map("n", "<M-S-Right>", "<Cmd>BufferMoveNext<CR>", {})
map("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", barbar_opts)
map("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", barbar_opts)
map("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", barbar_opts)
map("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", barbar_opts)
map("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", barbar_opts)
map("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", barbar_opts)
map("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", barbar_opts)
map("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", barbar_opts)
map("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", barbar_opts)
map("n", "<A-0>", "<Cmd>BufferLast<CR>", barbar_opts)

-- k/j and up/down will move virtual lines (lines that wrap)
map("n", "j", "gj", { desc = "Move up one display line" })
map("n", "k", "gk", { desc = "Move down one display line" })
map("n", "<Down>", "g<Down>", { desc = "Move up one display line" })
map("n", "<Up>", "g<Up>", { desc = "Move down one display line" })
map("", "<Home>", "g<Home>", { desc = "Move to the start of the display line" })
map("", "<End>", "g<End>", { desc = "Move to the end of the display line" })

-- Shift up/down to move cursor +/- 5 lines
map("", "<S-Up>", "5<Up>", { silent = true, noremap = true })
map("", "<S-Down>", "5<Down>", { silent = true, noremap = true })
map("i", "<S-Up>", "<C-O>5<Up>", { silent = true, noremap = true })
map("i", "<S-Down>", "<C-O>5<Down>", { silent = true, noremap = true })
-- Control up/down to scroll +/- 5 lines
map("", "<C-Up>", "5<C-y>", { silent = true, noremap = true })
map("", "<C-Down>", "5<C-e>", { silent = true, noremap = true })
map("i", "<C-Up>", "<C-O>5<C-y>", { silent = true, noremap = true })
map("i", "<C-Down>", "<C-O>5<C-e>", { silent = true, noremap = true })

-- Move line up or down
map("n", "<A-Up>", ":MoveLine(-1)<CR>", { noremap = true, silent = true })
map("n", "<A-Down>", ":MoveLine(1)<CR>", { noremap = true, silent = true })
map("i", "<A-Up>", "<C-O>:MoveLine(-1)<CR>", { noremap = true, silent = true })
map("i", "<A-Down>", "<C-O>:MoveLine(1)<CR>", { noremap = true, silent = true })
map("v", "<A-Up>", ":MoveBlock(-1)<CR>", { noremap = true, silent = true })
map("v", "<A-Down>", ":MoveBlock(1)<CR>", { noremap = true, silent = true })

-- Better indenting
map("v", "<", "<gv", { silent = true, noremap = true })
map("v", ">", ">gv", { silent = true, noremap = true })
map("v", "<A-Left>", "<gv", { silent = true, noremap = false })
map("v", "<A-Right>", ">gv", { silent = true, noremap = false })
map("n", "<A-Left>", "<<", { silent = true, noremap = false })
map("n", "<A-Right>", ">>", { silent = true, noremap = false })

-- Git
map("n", "äh", ":Gitsigns next_hunk <CR>", { silent = true })
map("n", "öh", ":Gitsigns prev_hunk <CR>", { silent = true })

-- Comments
map("n", "<C-c>", ":CommentToggle<CR>", { silent = true, noremap = false })
map("v", "<C-c>", ":CommentToggle<CR>", { silent = true, noremap = false })

-- LSP
-- Go to definition
map("n", "gs", "<cmd>Telescope lsp_definitions<CR>", lsp_opts)
-- Go to type_definition
map("n", "gy", "<cmd>Telescope lsp_type_definitions<CR>", lsp_opts)
-- Go to implementation
map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", lsp_opts)
-- References
map("n", "gr", function()
    require("telescope.builtin").lsp_references({ jump_type = "never" })
end, lsp_opts)
-- Show hover info
map("n", "K", function()
    vim.lsp.buf.hover({ border = "rounded", focusable = true, max_width = 80, max_height = 30 })
end, lsp_opts)
-- Show method signature
map({ "i", "n" }, "<C-s>", function()
    local base_win_id = vim.api.nvim_get_current_win()
    local windows = vim.api.nvim_tabpage_list_wins(0)
    for _, win_id in ipairs(windows) do
        if win_id ~= base_win_id then
            local win_cfg = vim.api.nvim_win_get_config(win_id)
            if win_cfg.relative == "win" and win_cfg.win == base_win_id then
                -- Toggle
                vim.api.nvim_win_close(win_id, false)
                return
            end
        end
    end
    vim.lsp.buf.signature_help({ border = "rounded", focusable = false, max_width = 80, max_height = 30 })
end, lsp_opts)
-- Workspace folder
-- map("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
--     lsp_opts)
-- map("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
--     lsp_opts)
-- map("n", "<space>wl",
--     "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
--     lsp_opts)
-- Rename
map("n", "<F2>", vim.lsp.buf.rename, lsp_opts)
-- Code Action
map("n", "<Leader>a", vim.lsp.buf.code_action, lsp_opts)
-- Show error popup
map("i", "<M-e>", vim.diagnostic.open_float, lsp_opts)
map("n", "<M-e>", vim.diagnostic.open_float, lsp_opts)
-- Jump to previous diagnostic
map("n", "ög", function()
    vim.diagnostic.jump({ count = -1, float = true })
end, lsp_opts)
-- Jump to next diagnostic
map("n", "äg", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, lsp_opts)
-- Show diagnostics list
map("n", "<A-S-w>", "<cmd>Telescope diagnostics<CR>", lsp_opts)
-- Formatting
map({ "i", "n", "v" }, "<C-M-b>", vim.lsp.buf.format, lsp_opts)
-- Illuminate
map("n", "<A-n>", function()
    require("illuminate").next_reference({ wrap = true })
end, { noremap = true })
map("n", "<A-S-n>", function()
    require("illuminate").next_reference({ reverse = true, wrap = true })
end, { noremap = true })

-- Floating Terminal
map("n", "<F7>", [[<CMD>lua require("FTerm").toggle()<CR>]], opts)
map("t", "<F7>", [[<C-\><C-n><CMD>lua require("FTerm").toggle()<CR>]], opts)
map("t", "<F9>", [[<C-\><C-n><CMD>lua require("FTerm").exit()<CR>]], opts)

-- Floating LazyGit
map("n", "<F8>", "<CMD>LazyGit<CR>", opts)
map("t", "<F8>", "<C-\\><C-n><CMD>LazyGit<CR>", opts)
map("t", "<F10>", "<C-\\><C-n><CMD>LazyGitClose<CR>", opts)

-- CCC Color adjuster
map("n", "<leader>c", [[<cmd>CccPick<CR>]], { noremap = true, silent = true })

--
-- Telescope
--

-- Options Menu Window
map("n", "<F5>", require("custom.optionsWindow").show, opts)
-- Git Menu Window
map("n", "<F6>", function()
    showFloatingMenu({
        { title = "LazyGit", action = "LazyGit" },
        { title = "Git Hunk Highlight", action = "Gitsigns toggle_linehl" },
        { title = "Git Toggle Deleted", action = "Gitsigns toggle_deleted" },
        { title = "Git Diff", action = "Gitsigns diffthis" },
        { title = "Git log", action = "GV" },
        { title = "Open in browser", action = "GBrowse" },
    })
end, opts)

-- All CWD files (except gitignored)
map("n", "<Leader>f", function()
    telescopeFindFiles(true)
end, opts)
-- All CWD files
map("n", "<Leader>F", function()
    telescopeFindFiles(false)
end, opts)
-- Git files git-root
map("n", "<Leader>G", function()
    telescopeGFiles(false)
end, opts)
-- Git status files
map("n", "<Leader>g", require("telescope.builtin").git_status, opts)
-- Search for string inside of all files in CWD
map("n", "<Leader>s", require("telescope.builtin").live_grep, opts)
-- Search for string inside buffer
map("n", "<Leader>S", require("telescope.builtin").current_buffer_fuzzy_find, opts)
-- Search for open buffers
map("n", "<Leader>b", require("telescope.builtin").buffers, opts)
-- Lists previously open files
map("n", "<Leader>h", require("telescope.builtin").oldfiles, opts)
-- Lists normal mode keymappings
map("n", "<Leader>m", require("telescope.builtin").keymaps, opts)
map("n", "<Leader>t", [[<cmd>TodoTelescope<CR>]], opts)

-- Search for DAP breakpoints
map("n", "<Leader>B", require("telescope").extensions.dap.list_breakpoints, opts)
