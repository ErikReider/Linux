function shFunc()
    return {
        exe = "shfmt",
        args = {"-i 4", vim.api.nvim_buf_get_name(0)},
        stdin = true
    }
end

require('formatter').setup({
    logging = false,
    filetype = {
        vala = {
            function()
                vim.cmd("call Uncrustify('VALA')")
                return {exe = "echo", args = {}, stdin = false}
            end
        },
        sh = {shFunc},
        zsh = {shFunc},
        bash = {shFunc},
        lua = {
            function()
                return {exe = "lua-format", args = {}, stdin = true}
            end
        }
    }
})