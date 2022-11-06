local Terminal = require('toggleterm.terminal').Terminal
function _G.lazydocker_open()
    local lazydocker = Terminal:new({
        cmd = "lazydocker",
        dir = "git_dir",
        persist_size = false,
        direction = "float"
    })
    lazydocker:open()
end

vim.cmd("command! LazyDocker lua lazydocker_open()")
