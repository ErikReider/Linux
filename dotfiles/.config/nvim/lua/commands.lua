-- LazyGit
vim.api.nvim_create_user_command("LazyGit", function()
    Snacks.lazygit()
end, {})
vim.api.nvim_create_user_command("LazyGitClose", function()
    Snacks.lazygit():close()
end, {})

-- LazyDocker
---@type snacks.win
local lazyDocker_window = nil
vim.api.nvim_create_user_command("LazyDocker", function()
    if lazyDocker_window == nil then
        lazyDocker_window = Snacks.terminal.open("lazydocker", {
            style = "lazygit",
        })
    else
        lazyDocker_window:toggle()
    end
end, {})
