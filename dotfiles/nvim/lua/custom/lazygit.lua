local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({
    cmd = "lazygit",
    dir = "git_dir",
    hidden = true,
    direction = "float",
    float_opts = {winblend = 0}
})
function _lazygit_toggle() lazygit:toggle() end

vim.cmd("command! LazyGit lua _lazygit_toggle()")
