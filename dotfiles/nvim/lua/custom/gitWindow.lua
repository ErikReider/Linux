-- Open git options
function _G.GitWindowShow()
    showFloatingMenu({
        {title = "LazyGit", action = "LazyGit"},
        {title = "Git Hunk Highlight", action = "Gitsigns toggle_linehl"},
        {title = "Git Toggle Deleted", action = "Gitsigns toggle_deleted"},
        {title = "Git Diff", action = "Gitsigns diffthis"},
        {title = "Git log", action = "GV"},
        {title = "Open in browser", action = "GBrowse"}
    })
end
