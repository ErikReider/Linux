require("incline").setup({
    highlight = {
        groups = {
            InclineNormal = {
                default = true,
                group = "NormalFloat"
            },
            InclineNormalNC = {
                default = true,
                group = "BufferInactive"
            }
        }
    },
    ignore = {
        buftypes = "special",
        filetypes = {},
        floating_wins = true,
        unlisted_buffers = true,
        wintypes = "special"
    },
    render = function(props)
        local bufname = vim.api.nvim_buf_get_name(props.buf)
        if bufname == '' then
            return '[No name]'
        else
            bufname = vim.fn.fnamemodify(bufname, ':t')
        end
        return bufname
    end,
    window = {
        margin = {
            horizontal = { left = 1, right = 1 },
            vertical = { bottom = 1, top = 1 }
        },
        padding = { left = 1, right = 1 },
        padding_char = " ",
        placement = { horizontal = "right", vertical = "top" },
        width = "fit",
        zindex = 50
    }
})
