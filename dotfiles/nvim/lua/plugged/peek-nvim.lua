local peek = require('peek')

peek.setup({
    auto_load = false, -- whether to automatically load preview when
    -- entering another markdown buffer
    close_on_bdelete = true, -- close preview window on buffer delete
    syntax = true, -- enable syntax highlighting, affects performance
    theme = "dark", -- "dark" or "light"
    update_on_change = true,
    -- relevant if update_on_change is true
    throttle_at = 200000, -- start throttling when file exceeds this
    -- amount of bytes in size
    throttle_time = "auto" -- minimum amount of time in milliseconds
    -- that has to pass before starting new render
})

vim.api.nvim_create_user_command("PeekOpen", peek.open, {})
vim.api.nvim_create_user_command("PeekClose", peek.close, {})
vim.api.nvim_create_user_command("PeekOpenOrClose", function()
    if peek.is_open() then
        peek.close()
    else
        peek.open()
    end
end, {})

