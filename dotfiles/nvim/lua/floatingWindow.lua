local api = vim.api

local function callback()
    local buf = vim.api.nvim_get_current_buf()
    local options = api.nvim_buf_get_var(buf, "options")
    local r, _ = unpack(api.nvim_win_get_cursor(0))
    local option = options[r]["action"]
    vim.cmd(":close")
    vim.cmd(option)
end

--- open floating window with nice borders
local function open_floating_window(options)
    local optionNames = {}
    local maxStringLength = 0
    for _, v in pairs(options) do
        local str = v["title"]
        local len = string.len(str)
        if len > maxStringLength then maxStringLength = len end
        table.insert(optionNames, str)
    end
    if maxStringLength < 30 then maxStringLength = 20 end

    -- height and width of inner window
    local height = table.maxn(optionNames)
    local width = maxStringLength

    -- Center window
    local row = math.ceil(vim.o.lines - height) / 2
    local col = math.ceil(vim.o.columns - width) / 2

    local border_opts = {
        style = 'minimal',
        relative = 'editor',
        row = row - 1,
        col = col - 1,
        width = width + 2,
        height = height + 2
    }

    local opts = {
        style = 'minimal',
        relative = 'editor',
        row = row,
        col = col,
        width = width,
        height = height
    }

    local topleft, topright, botleft, botright
    local corner_chars = {'╭', '╮', '╰', '╯'}
    topleft, topright, botleft, botright = unpack(corner_chars)

    local border_lines = {topleft .. string.rep('─', width) .. topright}
    local middle_line = '│' .. string.rep(' ', width) .. '│'
    for _ = 1, height do table.insert(border_lines, middle_line) end
    table.insert(border_lines, botleft .. string.rep('─', width) .. botright)

    -- create a unlisted scratch buffer for the border
    local border_buffer = api.nvim_create_buf(false, true)

    -- set border_lines in the border buffer from start 0 to end -1 and strict_indexing false
    api.nvim_buf_set_lines(border_buffer, 0, -1, true, border_lines)
    -- create border window
    api.nvim_open_win(border_buffer, true, border_opts)
    -- highlight colors
    vim.cmd('set winhl=Normal:Floating')

    -- create a unlisted scratch buffer
    buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_var(buf, "options", options)
    api.nvim_buf_set_lines(buf, 0, -1, true, optionNames)
    -- create file window, enter the window, and use the options defined in opts
    api.nvim_open_win(buf, true, opts)

    api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>",
                            {silent = true, nowait = true, noremap = true})
    api.nvim_buf_set_keymap(buf, "n", "<Enter>",
                            ":lua require('floatingWindow').callback()<CR>",
                            {silent = true, nowait = true, noremap = true})

    -- use autocommand to ensure that the border_buffer closes at the same time as the main buffer
    local cmd = [[autocmd WinLeave <buffer> silent! execute 'hide']]
    vim.cmd(cmd)
    cmd = [[autocmd WinLeave <buffer> silent! execute 'silent bdelete! %s']]
    vim.cmd(cmd:format(border_buffer))
end

return {open = open_floating_window, callback = callback}
