-- Show line number
vim.o.number = true

-- Sets the command height to 0 rows
vim.o.cmdheight = 1

-- If this many milliseconds nothing is typed the swap file will be written to disk
vim.o.updatetime = 300

-- always show signcolumns
vim.o.signcolumn = "yes:1"

-- Set <leader> key
vim.g.mapleader = " "
-- Key timeout eg. leader timeout
vim.o.timeoutlen = 1500

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

-- Folding
vim.o.foldcolumn = "auto:1"
vim.o.foldlevel = 99 -- feel free to decrease the value
vim.o.foldlevelstart = 99 -- feel free to decrease the value
-- Turn on auto folding on start
vim.o.foldenable = true
-- Max nested folds
vim.o.foldnestmax = 10

-- Makes popup menu smaller
vim.o.pumheight = 30

-- Support 256 colors
vim.cmd("set t_Co=256")

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

-- Never allow the cursor to go below / over +5 rows from the bottom / top
vim.o.scrolloff = 5

vim.o.wildmenu = true

vim.o.showmatch = true

-- When there is a previous search pattern, highlight all its matches
vim.o.hlsearch = true

-- Reloads open file on external modification
vim.bo.autoread = true

-- Yank to clipboard
vim.cmd("set clipboard=unnamedplus")

-- Select with mouse
vim.o.mouse = "a"

-- Shows the 80 char line
vim.o.colorcolumn = "80,100,120"

-- Encoding
vim.o.encoding = "UTF-8"

vim.o.laststatus = 3

-- Keep the line at the same position when creating splits
vim.o.splitkeep = "screen"

vim.g.virtcolumn_char = "▏" -- char to display the line
vim.g.virtcolumn_priority = 10 -- priority of extmark

vim.opt.title = true
vim.opt.titlestring = [[%(%{expand("%:p:~:h")}%) - %{v:progname}]]
vim.opt.titlelen = 15
