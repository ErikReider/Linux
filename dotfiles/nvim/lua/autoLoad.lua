-- auto source when writing to init.vm alternatively you can run :source $MYVIMRC
-- au! BufWritePost $MYVIMRC call feedkeys("\<F4>")
-- Remember folds
vim.api.nvim_create_augroup("remember_folds", {})
vim.api.nvim_create_autocmd("BufWinLeave", {
    group = "remember_folds",
    command = "silent! mkview"
})
vim.api.nvim_create_autocmd("BufWinEnter", {
    group = "remember_folds",
    command = "silent! loadview"
})
