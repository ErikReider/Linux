-- Syntax
return {
    -- BSPWM sxhk syntax
    { "kovetskiy/sxhkd-vim", ft = "conf" },
    -- Dockerfile syntax
    { "ekalinin/Dockerfile.vim", ft = "dockerfile" },
    -- i3 syntax highlighting
    { "mboughaba/i3config.vim", ft = "i3config" },
    -- Sway syntax highlighting
    { "ajouellette/sway-vim-syntax", ft = "sway" },
    -- Highlight Git conflicts
    {
        "rhysd/conflict-marker.vim",
        config = function()
            -- disable the default highlight group
            vim.g.conflict_marker_highlight_group = ""
            vim.g.conflict_marker_enable_mappings = 0

            -- Include text after begin and end markers
            vim.g.conflict_marker_begin = "^<<<<<<< .*$"
            vim.g.conflict_marker_end = "^>>>>>>> .*$"

            map("n", "äj", ":ConflictMarkerNextHunk <CR>", { silent = true })
            map("n", "öj", ":ConflictMarkerPrevHunk <CR>", { silent = true })
        end
    }
}
