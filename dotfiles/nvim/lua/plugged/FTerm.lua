require("FTerm").setup({
    border = 'single',
    auto_close = true,
    hl = 'Normal',
    blend = 20,
    dimensions  = {
        height = 0.9,
        width = 0.9,
    },
})

-- Example keybindings
local opts = { noremap = true, silent = true }

map('n', '<F7>', '<CMD>lua require("FTerm").toggle()<CR>', opts)
map('t', '<F7>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', opts)
map('t', '<F8>', '<C-\\><C-n><CMD>lua require("FTerm").exit()<CR>', opts)
