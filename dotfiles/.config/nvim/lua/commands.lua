pcall(require, "snacks")
local utils = require("utils")

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
vim.api.nvim_create_user_command("Bdelete", function()
    Snacks.bufdelete()
end, {
    bang = true,
    bar = true,
    count = true,
    addr = "buffers",
    nargs = "*",
    complete = "buffer",
})
vim.api.nvim_create_user_command("Bwipeout", function()
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
    vim.api.nvim_create_user_command("Restart", function()
        vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })

        -- Create a tmp file to save the session
        local file_path = os.tmpname()
        vim.cmd.mksession({ bang = true, args = { file_path } })
        -- Restore from the tmp file and remove it after the restart
        vim.cmd(string.format([[restart source %s | lua os.remove('%s')]], file_path, file_path))
    end, {})
end

-- Load resession picker
vim.api.nvim_create_user_command("SessionSelect", function()
    require("resession").load()
end, {})
vim.api.nvim_create_user_command("SessionDelete", function()
    require("resession").delete()
end, {})
vim.api.nvim_create_user_command("SessionSave", function()
    require("resession").save()
end, {})

-- Telescope pickers
vim.api.nvim_create_user_command("TelescopeFindFiles", function(opts)
    local no_git_ignore = opts.args == "no_git_ignore"
    local prompt_title = "All Files"
    if not no_git_ignore then
        if utils.cwd_is_git_repo_root() then
            prompt_title = "Git Filtered Files"
        else
            prompt_title = "CWD Git Filtered Files"
        end
    end
    local telescope_opts = {
        hidden = true,
        no_ignore = no_git_ignore,
        no_ignore_parent = no_git_ignore,
        prompt_title = prompt_title,
    }
    require("telescope.builtin").find_files(telescope_opts)
end, {
    desc = "Find files within the current working directory. Respects .gitignore by default.",
    nargs = "?",
    complete = function()
        return { "no_git_ignore" }
    end,
})
vim.api.nvim_create_user_command("TelescopeGitFiles", function(opts)
    local local_dir = opts.args == "local"
    local telescope_opts = {
        use_git_root = not local_dir,
        prompt_title = "Git Files " .. (local_dir and "CWD" or "ROOT"),
        show_untracked = true,
    }
    local ok = pcall(require("telescope.builtin").git_files, telescope_opts)
    if not ok then
        vim.cmd([[TelescopeFindFiles]])
    end
end, {
    desc = "Find files within the current Git repository. Fallback to files in current working directory.",
    nargs = "?",
    complete = function()
        return { "local" }
    end,
})
