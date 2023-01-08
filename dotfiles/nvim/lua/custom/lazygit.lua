local Terminal = require('toggleterm.terminal').Terminal
function _G.lazygit_open()
    local style = vim.g.gtk_style
    local configs = {}

    -- Use default config if it exists
    local default_conf = os.getenv("HOME") .. "/.config/lazygit/config.yml"
    if file_exists(default_conf) then table.insert(configs, default_conf) end

    -- Supply Light theme if using light mode
    if style == "light" then
        local light_conf = os.getenv("HOME") ..
                               "/.config/nvim/lazygit-light-config.yml"
        if file_exists(light_conf) then table.insert(configs, light_conf) end
    end

    local lazygit = Terminal:new({
        cmd = "lazygit --use-config-file=" .. table.concat(configs, ","),
        dir = "git_dir",
        persist_size = false,
        direction = "float"
    })
    lazygit:open()
end

vim.cmd("command! LazyGit lua lazygit_open()")
