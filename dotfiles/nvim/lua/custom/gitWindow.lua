-- Open git options
local popup = require("floatingWindow")({
    {title = "LazyGit", action = "LazyGit"},
    {title = "Git Hunk Highlight", action = "Gitsigns toggle_linehl"},
    {title = "Git Toggle Deleted", action = "Gitsigns toggle_deleted"},
    {title = "Git Diff", action = "Gitsigns diffthis"},
    {title = "Git log", action = "GV"},
    {title = "Open in browser", action = "GBrowse"}
})

function _G.GitWindowShow() popup:show() end

map("n", "<Leader>g", ":lua GitWindowShow()<CR>",
    {noremap = true, silent = true})
