-- Duplicate line
map('n', '<C-d>',
    ':exe \'set clipboard=""\' | exe \'normal yyp\' | exe \'set clipboard=unnamedplus\'<CR>',
    {silent = true})

-- Opens selected link in xdg default browser
-- https://vim.fandom.com/wiki/Open_a_web-browser_with_the_URL_in_the_current_line
map("n", "gx",
    ':silent !xdg-open <C-R>=escape("<C-R><C-F>", "#?&;\\|%")<CR> 2> /dev/null >&2 & disown<CR>',
    {silent = false})

-- open init.vim on F3 (split if buffer is selected)
map("n", "<F3>",
    "expand('%') == '' ? ':e $MYVIMRC <cr>' : ':vsplit $MYVIMRC <cr>'",
    {silent = true, expr = true})
-- Source on F4
map("n", "<F4>", ":checktime <CR> :source $MYVIMRC | redraw! <CR>", {})

-- Use double ESC to clear highlights
map("n", "<Esc><Esc>", ":nohl<CR>", {})

-- k/j and up/down will move virtual lines (lines that wrap)
map("n", "j", "(v:count == 0 ? 'gj' : 'j')",
    {noremap = false, silent = true, expr = true})
map("n", "k", "(v:count == 0 ? 'gk' : 'k')",
    {noremap = false, silent = true, expr = true})
map("n", "<Down>", "(v:count == 0 ? 'g<Down>' : '<Down>')",
    {noremap = false, silent = true, expr = true})
map("n", "<Up>", "(v:count == 0 ? 'g<Up>' : '<Up>')",
    {noremap = false, silent = true, expr = true})
map("", "<home>", "g<home>", {silent = true})
map("", "<End>", "g<End>", {silent = true})

-- Shift up/down to move cursor +/- 5 lines
map("", "<S-Up>", "5<Up>", {silent = true, noremap = true})
map("", "<S-Down>", "5<Down>", {silent = true, noremap = true})
map("i", "<S-Up>", "<C-O>5<Up>", {silent = true, noremap = true})
map("i", "<S-Down>", "<C-O>5<Down>", {silent = true, noremap = true})
-- Control up/down to scroll +/- 5 lines
map("", "<C-Up>", "5<C-y>", {silent = true, noremap = true})
map("", "<C-Down>", "5<C-e>", {silent = true, noremap = true})
map("i", "<C-Up>", "<C-O>5<C-y>", {silent = true, noremap = true})
map("i", "<C-Down>", "<C-O>5<C-e>", {silent = true, noremap = true})

-- Move line up or down
map("n", "<A-Up>", ":m-2<CR>", {noremap = true, silent = true})
map("n", "<A-Down>", ":m+<CR>", {noremap = true, silent = true})
map("i", "<A-Up>", "<C-O>:m-2<CR>", {noremap = true, silent = true})
map("i", "<A-Down>", "<C-O>:m+<CR>", {noremap = true, silent = true})

-- Move window with arrow keys (C-w)
map("n", "<C-S-Left>", ":wincmd h <CR>", {silent = true, noremap = true})
map("n", "<C-S-Down>", ":wincmd j <CR>", {silent = true, noremap = true})
map("n", "<C-S-Up>", ":wincmd k <CR>", {silent = true, noremap = true})
map("n", "<C-S-Right>", ":wincmd l <CR>", {silent = true, noremap = true})

-- Resize window (M = alt)
map("n", "<M-S-Up>", ":resize -2 <CR>", {silent = true, noremap = true})
map("n", "<M-S-Down>", ":resize +2 <CR>", {silent = true, noremap = true})
map("n", "<M-S-Right>", ":vertical resize -2 <CR>",
    {silent = true, noremap = true})
map("n", "<M-S-Left>", ":vertical resize +2 <CR>",
    {silent = true, noremap = true})

-- Better indenting
map("v", "<", "<gv", {silent = true, noremap = true})
map("v", ">", ">gv", {silent = true, noremap = true})
map("v", "<A-Left>", "<", {silent = true, noremap = false})
map("v", "<A-Right>", ">", {silent = true, noremap = false})
map("n", "<A-Left>", "<<", {silent = true, noremap = false})
map("n", "<A-Right>", ">>", {silent = true, noremap = false})

-- Git
map("n", "äh", ":Gitsigns next_hunk <CR>", { silent = true })
map("n", "öh", ":Gitsigns prev_hunk <CR>", { silent = true })

-- LSP
local lsp_opts = {noremap = true, silent = true}
-- Go to definition
map("n", "gd", "<cmd>lua goto_definition(true)<CR>", lsp_opts)
map("n", "gs", "<cmd>lua goto_definition()<CR>", lsp_opts)
map("n", "ga", "<cmd>Lspsaga preview_definition<CR>", lsp_opts)
-- Go to type_definition
map("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", lsp_opts)
-- Go to implementation
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", lsp_opts)
-- References
map("n", "gr", "<cmd>Telescope lsp_references<CR>", lsp_opts)
-- Show hover info
map("n", "K", "<cmd>Lspsaga hover_doc<CR>", lsp_opts)
-- Show method signature
map("i", "<M-x>", "<cmd>lua require('lsp_signature').toggle_float_win()<CR>", lsp_opts)
map("n", "<M-x>", "<cmd>lua require('lsp_signature').toggle_float_win()<CR>", lsp_opts)
-- Workspace folder
map("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
    lsp_opts)
map("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
    lsp_opts)
map("n", "<space>wl",
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    lsp_opts)
-- Rename
map("n", "<F2>", ":Lspsaga rename<CR>", lsp_opts)
-- Code Action
map("n", "<leader>a", "<cmd>Lspsaga code_action<CR>", lsp_opts)
-- Show error popup
map("i", "<M-e>", "<cmd>Lspsaga show_line_diagnostics<CR>", lsp_opts)
map("n", "<M-e>", "<cmd>Lspsaga show_line_diagnostics<CR>", lsp_opts)
-- Next/Previous diagnostic
map("n", "ög", "<cmd>Lspsaga diagnostic_jump_prev<CR>", lsp_opts)
map("n", "äg", "<cmd>Lspsaga diagnostic_jump_next<CR>", lsp_opts)
-- Show diagnostics list
map("n", "<A-S-w>", "<cmd>Telescope diagnostics<CR>", lsp_opts)
-- Formatting
map("i", "<C-M-b>", "<cmd>lua vim.lsp.buf.format({async=true})<CR>", lsp_opts)
map("n", "<C-M-b>", "<cmd>lua vim.lsp.buf.format({async=true})<CR>", lsp_opts)
-- Illuminate
map('n', '<A-n>',
    '<cmd>lua require("illuminate").next_reference{wrap=true}<cr>',
    {noremap = true})
map('n', '<A-S-n>',
    '<cmd>lua require("illuminate").next_reference{reverse=true,wrap=true}<cr>',
    {noremap = true})
