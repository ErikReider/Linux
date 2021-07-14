-- Open git options
local gitWindowOptions = vim.inspect({
    {title = "LazyGit", action = "LazyGit"},
    {title = "Git Diff", action = "Gdiffsplit"},
    {title = "Git log", action = "GV"},
    {title = "Open in browser", action = "GBrowse"},
}, {newline = '', indent = ""})
map("n", "<Leader>g",
    ":lua require('floatingWindow').open(" .. gitWindowOptions .. ")<CR>",
    {noremap = true, silent = true})
