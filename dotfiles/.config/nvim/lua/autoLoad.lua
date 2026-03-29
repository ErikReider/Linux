-- SCSS: add '@' to keyword (includes said character when navigating)
vim.api.nvim_create_autocmd(
    "FileType",
    { pattern = { "scss", "css", "less", "sass" }, command = "setl iskeyword+=@-@" }
)

-- HACK: Used until https://github.com/folke/lazy.nvim/issues/1951 is fixed
vim.api.nvim_create_autocmd("FileType", {
    desc = "User: fix backdrop for lazy window",
    pattern = "lazy_backdrop",
    group = vim.api.nvim_create_augroup("lazynvim-fix", { clear = true }),
    callback = function(ctx)
        local win = vim.fn.win_findbuf(ctx.buf)[1]
        vim.api.nvim_win_set_config(win, { border = "none" })
    end,
})
