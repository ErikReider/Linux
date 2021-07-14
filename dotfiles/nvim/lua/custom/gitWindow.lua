-- Open git options
local gitWindowOptions = vim.inspect({
    {title = "LazyGit", action = "LazyGit"},
    {title = "Git Diff", action = "Gdiffsplit"}
}, {newline = '', indent = ""})
map("n", "<Leader>g",
    ":lua require('floatingWindow').open(" .. gitWindowOptions .. ")<CR>",
    {noremap = true, silent = true})
