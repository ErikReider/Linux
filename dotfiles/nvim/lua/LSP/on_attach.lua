-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
_G.clients = {}
return function(client, bufnr)
    clients[client.name] = client.resolved_capabilities
    local function buf_set_keymap(is_valid, message, type, keys, cmd, ops)
        -- Check if keymap already exists
        local error_msg = [[<cmd>echo "Server doesn't support ]] .. message ..
                              [[!"<CR>]]

        local found = false;
        local _key = vim.api.nvim_replace_termcodes(keys, true, true, true)
        local _cmd = vim.api.nvim_replace_termcodes(cmd, true, true, true)
        for _, value in ipairs(vim.api.nvim_buf_get_keymap(bufnr, type)) do
            local loop_key = vim.api.nvim_replace_termcodes(value["lhs"], true,
                                                            true, true)
            local action = vim.api.nvim_replace_termcodes(value["rhs"], true,
                                                          true, true)
            if loop_key == _key then
                if action == error_msg or action == _cmd then
                    found = true
                    break
                end
            end
        end
        if found and not is_valid then return end
        vim.api.nvim_buf_set_keymap(bufnr, type, keys,
                                    is_valid and cmd or error_msg, ops)
    end
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    require("LSP.illuminate").init(client)

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings
    local opts = {noremap = true, silent = true}

    local has_go_def = client.resolved_capabilities.goto_definition
    -- Go to definition in new tab. TODO: Do not create new tab if in same file
    buf_set_keymap(has_go_def, "go_to_definition", 'n', 'gd',
                   '<cmd>lua goto_definition(true)<CR>', opts)
    -- Go to definition
    buf_set_keymap(has_go_def, "go_to_definition", 'n', 'gs',
                   '<cmd>lua goto_definition()<CR>', opts)
    -- Preview Definition
    buf_set_keymap(has_go_def, "previewing definition", 'n', 'ga',
                   ':Lspsaga preview_definition<CR>', opts)

    -- Go to type_definition
    buf_set_keymap(client.resolved_capabilities.type_definition,
                   "type definition", 'n', 'gy',
                   '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

    -- Go to implementation
    buf_set_keymap(client.resolved_capabilities.find_implementations,
                   "finding implementations", 'n', 'gi',
                   '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)

    -- References
    buf_set_keymap(client.resolved_capabilities.find_references,
                   "finding references", 'n', 'gr',
                   '<cmd>Telescope lsp_references<CR>', opts)

    -- Show hover info
    buf_set_keymap(client.resolved_capabilities.hover, "hover", 'n', 'K',
                   '<cmd>Lspsaga hover_doc<CR>', opts)

    -- Highlight variables on cursor hold
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold,CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]], false)
    end

    -- Show method signature
    buf_set_keymap(client.resolved_capabilities.signature_help,
                   "type signature help", 'i', '<M-x>',
                   '<cmd>Lspsaga signature_help<CR>', opts)
    buf_set_keymap(client.resolved_capabilities.signature_help,
                   "type signature help", 'n', '<M-x>',
                   '<cmd>Lspsaga signature_help<CR>', opts)

    buf_set_keymap(true, "", 'n', '<space>wa',
                   '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap(true, "", 'n', '<space>wr',
                   '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap(true, "", 'n', '<space>wl',
                   '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
                   opts)

    -- Rename
    -- buf_set_keymap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap(client.resolved_capabilities.rename, "renaming", 'n', '<F2>',
                   ':Lspsaga rename<CR>', opts)

    -- Code Action
    buf_set_keymap(client.resolved_capabilities.code_action, "code_actions",
                   'n', '<leader>a', '<cmd>Lspsaga code_action<CR>', opts)

    -- Show error popup
    -- buf_set_keymap(true, "", 'n', '<M-e>',
    -- '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})<CR>',
    -- opts)
    buf_set_keymap(true, "", 'n', '<M-e>',
                   '<cmd>Lspsaga show_line_diagnostics<CR>', opts)
    buf_set_keymap(true, "", 'i', '<M-e>',
                   '<cmd>Lspsaga show_line_diagnostics<CR>', opts)

    -- Next/Previous diagnostic
    buf_set_keymap(true, "", 'n', 'ög',
                   '<cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
    buf_set_keymap(true, "", 'n', 'äg',
                   '<cmd>Lspsaga diagnostic_jump_next<CR>', opts)

    -- Show diagnostics list
    buf_set_keymap(true, "", 'n', '<A-S-w>',
                   '<cmd>Telescope lsp_workspace_diagnostics<CR>', opts)

    -- Formatting
    buf_set_keymap(client.resolved_capabilities.document_formatting,
                   "formatting", 'n', '<C-M-b>',
                   '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end
