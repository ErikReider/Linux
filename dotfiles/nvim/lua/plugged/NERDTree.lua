-- Navigate to CWD on nerdtree open
function _G.openNerdTree()
    local command = ""
    if vim.g.NERDTree and vim.api.nvim_eval("g:NERDTree.IsOpen()") == 1 then
        command = ":NERDTreeClose"
    else
        command = ":NERDTreeCWD"
    end
    return vim.api.nvim_replace_termcodes(command .. "<CR>", true, true, true)
end
vim.api.nvim_set_keymap('n', '<C-S-n>', 'v:lua.openNerdTree()',
                        {silent = true, expr = true})
vim.api.nvim_set_keymap('n', '<C-n>', ':NERDTreeToggle <CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-m>', ":NERDTreeFind <CR>", {silent = true})

vim.api.nvim_set_var("NERDTreeGitStatusWithFlags", 1)
vim.api.nvim_set_var("WebDevIconsUnicodeDecorateFolderNodes", 1)
vim.api.nvim_set_var("NERDTreeShowHidden", 1)
vim.api.nvim_set_var("NERDTreeIgnore", {'^node_modules$'})
