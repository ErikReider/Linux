-- local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- auto source when writing to init.vm alternatively you can run :source $MYVIMRC
-- au! BufWritePost $MYVIMRC call feedkeys("\<F4>")
-- Remember folds
-- augroup("remember_folds", {})
-- autocmd("BufWinLeave", {
--     group = "remember_folds",
--     command = "silent! mkview"
-- })
-- autocmd("BufWinEnter", {
--     group = "remember_folds",
--     command = "silent! loadview"
-- })

-- Set titlestring
-- autocmd BufEnter * let &titlestring = "neovim: " . expand("%:t")
-- autocmd("BufEnter", { pattern = "*", command = [[let &titlestring = "neovim: " . expand("%:t")]] })

-- SCSS Tweaks
autocmd("FileType", { pattern = "scss", command = "setl iskeyword+=@-@" })
