local map = vim.api.nvim_set_keymap

-- Duplicate line
map('n', '<C-d>', ':exe \'set clipboard=""\' | exe \'normal yyp\' | exe \'set clipboard=unnamedplus\'<CR>', {silent = true})

-- Closes on escape if not a terminal window
function _G.terminalNormalMode()
  local buffer = tostring(vim.api.nvim_eval("expand('%')"))
  local command = ""
  if (vim.env.SHELL ~= string.sub(buffer, buffer:match'^.*():' + 1, string.len(buffer))) then
    command = ":q!<CR>"
  end
  return vim.api.nvim_replace_termcodes("<C-\\><C-n>" .. command, true, true, true)
end
map('t', '<Esc>', 'v:lua.terminalNormalMode()', {silent = true, expr = true})

-- Opens selected link in xdg default browser
-- https://vim.fandom.com/wiki/Open_a_web-browser_with_the_URL_in_the_current_line
map("n", "gx", ':silent !xdg-open <C-R>=escape("<C-R><C-F>", "#?&;\\|%")<CR><CR>', {silent = true})

-- open init.vim on F3 (split if buffer is selected)
map("n", "<F3>", "expand('%') == '' ? ':e $MYVIMRC <cr>' : ':vsplit $MYVIMRC <cr>'", {silent = true, expr = true})
-- Source on F4
map("n", "<F4>", ":checktime <CR> :source $MYVIMRC | redraw! <CR>", {})

-- Use ESC to clear highlights
map("n", "<Esc><Esc>", ":nohl<CR>", {})

-- k/j and up/down will move virtual lines (lines that wrap)
map("n", "j", "(v:count == 0 ? 'gj' : 'j')", {noremap = false, silent = true, expr = true})
map("n", "k", "(v:count == 0 ? 'gk' : 'k')", {noremap = false, silent = true, expr = true})
map("n", "<Down>", "(v:count == 0 ? 'g<Down>' : '<Down>')", {noremap = false, silent = true, expr = true})
map("n", "<Up>", "(v:count == 0 ? 'g<Up>' : '<Up>')", {noremap = false, silent = true, expr = true})
map("", "<home>", "g<home>", {silent = true})
map("", "<End>", "g<End>", {silent = true})

-- Switch tabs
map("n", "<TAB>", ":tabn<CR>", {silent =true})
map("n", "<S-TAB>", ":tabp<CR>", {silent =true})

-- Move line up or down
map("n", "<A-Up>", ":m-2<CR>", {noremap= true, silent =true})
map("n", "<A-Down>", ":m+<CR>", {noremap= true, silent =true})

-- Move window with arrow keys (C-w)
map("n", "<C-S-Left>", ":wincmd h <CR>", {silent = true, noremap = true})
map("n", "<C-S-Down>", ":wincmd j <CR>", {silent = true, noremap = true})
map("n", "<C-S-Up>", ":wincmd k <CR>", {silent = true, noremap = true})
map("n", "<C-S-Right>", ":wincmd l <CR>", {silent = true, noremap = true})

-- Resize window (M = alt)
map("n", "<M-S-Up>", ":resize -2 <CR>", {silent = true, noremap = true})
map("n", "<M-S-Down>", ":resize +2 <CR>", {silent = true, noremap = true})
map("n", "<M-S-Right>", ":vertical resize -2 <CR>", {silent = true, noremap = true})
map("n", "<M-S-Left>", ":vertical resize +2 <CR>", {silent = true, noremap = true})

-- Better indenting
map("v", "<", "<gv", {silent = true, noremap = true})
map("v", ">", ">gv", {silent = true, noremap = true})
map("v", "<A-Left>", "<", {silent = true, noremap = false})
map("v", "<A-Right>", ">", {silent = true, noremap = false})
map("", "<A-Left>", "<<", {silent = true, noremap = false})
map("", "<A-Right>", ">>", {silent = true, noremap = false})
