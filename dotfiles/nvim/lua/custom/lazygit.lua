local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({
    cmd = "lazygit",
    dir = "git_dir",
    hidden = true,
    direction = "float",
    float_opts = {winblend = 20, border = "rounded"}
})
function _G.lazygit_toggle() lazygit:toggle() end

vim.cmd("command! LazyGit lua lazygit_toggle()")
