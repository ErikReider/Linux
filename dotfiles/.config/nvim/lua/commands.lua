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

-- Delete Neovim buffers without losing window layout
-- Define Bdelete and Bwipeout.
vim.api.nvim_create_user_command("Bdelete", function(opts)
    Snacks.bufdelete()
end, {
    bang = true,
    bar = true,
    count = true,
    addr = "buffers",
    nargs = "*",
    complete = "buffer",
})
vim.api.nvim_create_user_command("Bwipeout", function(opts)
    Snacks.bufdelete({ wipe = true })
end, {
    bang = true,
    bar = true,
    count = true,
    addr = "buffers",
    nargs = "*",
    complete = "buffer",
})
