-- disable the default highlight group
vim.g.conflict_marker_highlight_group = ""
vim.g.conflict_marker_enable_mappings = 0

-- Include text after begin and end markers
vim.g.conflict_marker_begin = "^<<<<<<< .*$"
vim.g.conflict_marker_end = "^>>>>>>> .*$"
