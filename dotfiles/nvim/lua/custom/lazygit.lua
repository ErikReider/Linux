local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({
    cmd = "lazygit",
    dir = "git_dir",
    hidden = true,
    direction = "float",
    float_opts = {winblend = 0},
})

function _lazygit_toggle() lazygit:toggle() end

map("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>",
    {noremap = true, silent = true})
