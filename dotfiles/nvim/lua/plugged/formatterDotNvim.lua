function shFunc()
    vim.cmd("Shfmt -i 4")
    return {exe = "echo", args = {}, stdin = false}
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
