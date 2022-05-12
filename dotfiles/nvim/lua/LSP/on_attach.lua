-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
_G.clients = {}
return function(client, bufnr)
    clients[client.name] = client.server_capabilities
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    require('illuminate').on_attach(client)

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end
