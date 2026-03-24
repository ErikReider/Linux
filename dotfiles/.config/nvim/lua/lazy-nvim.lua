-- Install lazy.nvim Plugin Manager if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

return {
    ---@param spec LazySpec Lazy spec to import
    setup = function(spec)
        require("lazy").setup({
            change_detection = {
                -- automatically check for config file changes and reload the ui
                enabled = true,
                notify = false, -- get a notification when changes are found
            },
            spec = spec,
        })
    end,
}
