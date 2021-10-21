-- Show line number
vim.o.number = true

-- Sets the command height to 2 rows
vim.o.cmdheight = 2

-- If this many milliseconds nothing is typed the swap file will be written to disk
vim.o.updatetime = 300

-- always show signcolumns
vim.o.signcolumn = "yes"

-- Key timeout eg. leader timeout
vim.o.timeoutlen = 750

-- Easier to read long lines
vim.o.linebreak = true

-- Do smart autoindenting when starting a new line
vim.o.smartindent = true
-- Copy indent from current line when starting a new line
vim.o.autoindent = true
-- When on, a <Tab> in front of a line inserts blanks according to 'shiftwidth'
vim.o.smarttab = true

-- Defaults for new files
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 2

-- Split direction
vim.o.splitbelow = true
vim.o.splitright = true

-- Use Treesitter method in its file
-- Max nested folds
vim.o.foldnestmax = 10
-- Turn off auto folding on start
vim.o.foldenable = false
-- vim.o.foldlevel=2

-- Makes popup menu smaller
vim.o.pumheight = 30

-- treat dash separated words as a word text object"
vim.cmd('set iskeyword+=-')

-- Support 256 colors
vim.cmd('set t_Co=256')

-- Disable quote concealing in JSON files
vim.api.nvim_set_var("vim_json_conceal", 0)

-- So that I can see `` in markdown files
vim.o.conceallevel = 0

-- This is recommended by coc
vim.o.backup = false
-- This is recommended by coc
vim.o.writebackup = false

-- Always show top tabline
vim.o.showtabline = 2

vim.cmd("filetype plugin on")

vim.cmd("set cursorline")

vim.cmd("set nocompatible")

vim.o.wildmenu = true

vim.o.showmatch = true

-- When there is a previous search pattern, highlight all its matches
vim.o.hlsearch = true

-- Reloads open file on external modification
vim.bo.autoread = true

-- Yank to clipboard
vim.cmd('set clipboard=unnamedplus')

-- Select with mouse
vim.o.mouse = "a"

-- Shows the 80 char line
vim.o.colorcolumn = "80"

-- Encoding
vim.o.encoding = "UTF-8"
