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

-- Restart while saving session
if vim.fn.has("nvim-0.12") then
    vim.api.nvim_create_user_command("Restart", function(opts)
        -- Create a tmp file to save the session
        local file_path = os.tmpname()
        vim.cmd(string.format("mksession! %s", file_path))
        -- Restore from the tmp file and remove it after the restart
        vim.cmd(string.format([[restart source %s | lua os.remove('%s')]], file_path, file_path))
    end, {})
end
