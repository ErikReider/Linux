local fterm = require("FTerm")

local window = nil

local function new_window()
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

    return fterm:new({
        cmd = "lazygit --use-config-file=" .. table.concat(configs, ","),
        dimensions = {height = 0.9, width = 0.9}
    })
end

vim.api.nvim_create_user_command("LazyGit", function()
    if window == nil then
        window = new_window()
        window:open()
    else
        window:toggle()
    end
end, {})

-- Be able to close when theme changes (lazygit theme doesn't hotreload...)
vim.api.nvim_create_user_command("LazyGitClose", function()
    if window ~= nil then window:close() end
    window = nil
end, {})

local opts = {noremap = true, silent = true}
map('n', '<F8>', '<CMD>LazyGit<CR>', opts)
map('t', '<F8>', '<C-\\><C-n><CMD>LazyGit<CR>', opts)
map('t', '<F10>', '<C-\\><C-n><CMD>LazyGitClose<CR>', opts)
