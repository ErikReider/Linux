local api = vim.api

local function set_buf_keymap(buf, mode, key, callback, options)
    local callback_string
    if type(callback) == "string" then
        callback_string = callback
    elseif type(callback) == "function" then
        if not _G.set_keymap_index then _G.set_keymap_index = 1 end
        local index = _G.set_keymap_index
        _G.set_keymap_index = _G.set_keymap_index + 1
        _G["set_keymap_callback_" .. index] = callback
        callback_string = "v:lua set_keymap_callback_" .. index .. "()<CR>"
    end
    api.nvim_buf_set_keymap(buf, mode, key, callback_string, options)
end

local function callback()
    local buf = vim.api.nvim_get_current_buf()
    local options = api.nvim_buf_get_var(buf, "options")
    local r, _ = unpack(api.nvim_win_get_cursor(0))
    local option = options[r]["action"]
    vim.cmd(":close")
    vim.cmd(option)
end

local FloatingWindow = {}

local function constructor(class, options)
    local self = setmetatable({}, class)

    -- create a unlisted scratch buffer for the border
    self.border_buffer = api.nvim_create_buf(false, true)

    -- create a unlisted scratch buffer
    self.buf = api.nvim_create_buf(false, true)

    api.nvim_buf_set_keymap(self.buf, "n", "<Esc>", ":close<CR>",
                            {silent = true, nowait = true, noremap = true})

    set_buf_keymap(self.buf, "n", "<Enter>", callback,
                   {silent = true, nowait = true, noremap = true})

    self:setOptions(options)

    return self
end

function FloatingWindow:init(options) return constructor(self, options) end

function FloatingWindow:setOptions(options)
    api.nvim_buf_set_var(self.buf, "options", options)
    self.options = {}
    self.optionNames = {}
    self.maxStringLength = 0

    if type(options) == "table" and table.maxn(options) > 0 then
        self.options = options
        for _, v in pairs(options) do
            local str = v["title"]
            local len = string.len(str)
            if len > self.maxStringLength then
                self.maxStringLength = len
            end
            table.insert(self.optionNames, str)
        end
        if self.maxStringLength < 30 then self.maxStringLength = 20 end
    end
end

function FloatingWindow:show(options)
    if type(options) == "table" then self:setOptions(options) end

    if table.maxn(self.options) <= 0 then
        print("No options provided for floating window")
        return
    end

    -- height and width of inner window
    local height = table.maxn(self.optionNames)
    local width = self.maxStringLength

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

    -- set border_lines in the border buffer from start 0 to end -1 and strict_indexing false
    api.nvim_buf_set_lines(self.border_buffer, 0, -1, true, border_lines)
    -- create border window
    api.nvim_open_win(self.border_buffer, true, border_opts)
    -- highlight colors
    vim.cmd('set winhl=Normal:Floating,CursorLine:PmenuSel')

    -- Adds the options
    api.nvim_buf_set_option(self.buf, 'modifiable', true)
    api.nvim_buf_set_lines(self.buf, 0, -1, true, self.optionNames)
    api.nvim_buf_set_option(self.buf, 'modifiable', false)

    -- create file window, enter the window, and use the options defined in opts
    api.nvim_open_win(self.buf, true, opts)

    -- Reset cursor position
    vim.api.nvim_win_set_cursor(0, {1, 0})

    api.nvim_win_set_option(0, 'cursorline', true)

    -- use autocommand to ensure that the border_buffer closes at the same time as the main buffer
    local cmd = [[autocmd WinLeave <buffer> silent! execute 'hide']]
    vim.cmd(cmd)
    cmd = [[autocmd WinLeave <buffer> silent! execute 'silent bdelete! %s']]
    vim.cmd(cmd:format(self.border_buffer))
end

return setmetatable({__index = FloatingWindow},
                    {__call = constructor, __index = FloatingWindow})
