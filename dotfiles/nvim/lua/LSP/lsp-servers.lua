-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
local nvim_lsp = require('lspconfig')
local on_attach = require("LSP.on_attach")
local util = require("lspconfig/util")

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- For nvim-ufo
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
local servers = {
    -- No configuration needed
    "vimls", "cssls", "texlab", "intelephense", "lemminx", "dockerls"
}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        flags = {debounce_text_changes = 150},
        capabilities = capabilities
    }
end

-- Lua
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
nvim_lsp.sumneko_lua.setup({
    on_attach = on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities,
    cmd = {"lua-language-server"},
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = runtime_path
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {"vim"}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true)
            },
            telemetry = {enable = false},
            format = {enable = false}
        }
    }
})

nvim_lsp.vala_ls.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities
})

-- TypeScript/JavaScript
nvim_lsp.tsserver.setup({
    on_attach = function(client, bufnr)
        if client.config.flags then
            client.config.flags.allow_incremental_sync = true
        end
        client.server_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities,
    filetypes = {
        "javascript", "javascriptreact", "javascript.jsx", "typescript",
        "typescriptreact", "typescript.tsx"
    },
    init_options = {
        hostInfo = "neovim",
        preferences = {
            includeCompletionsWithSnippetText = true,
            includeCompletionsForImportStatements = true
        }
    }
})

nvim_lsp.stylelint_lsp.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities
})

nvim_lsp.emmet_ls.setup({
    on_attach = on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities,
    root_dir = function(fname)
        return util.root_pattern('package.json', '.git')(fname) or
                   util.path.dirname(fname)
    end,
    filetypes = {
        'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss',
        'less', "heex", "htmldjango"
    }
})

-- CSharp
nvim_lsp.omnisharp.setup({
    on_attach = on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities,
    cmd = {
        "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid())
    }
})

-- Clangd
nvim_lsp.clangd.setup({
    on_attach = on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities,
    cmd = {"clangd", "-fallback-style=Google"}
})

-- Bash
nvim_lsp.bashls.setup({
    on_attach = on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities,
    cmd = {"bash-language-server", "start"},
    filetypes = {"sh", "zsh", "bash"}
})

-- HTML
nvim_lsp.html.setup({
    on_attach = function(client, bufnr, ...)
        client.server_capabilities.document_formatting = false
        client.server_capabilities.documentFormattingProvider = false
        on_attach(client, bufnr, ...)
    end,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities,
    cmd = {"vscode-html-language-server", "--stdio"},
    filetypes = {"html", "heex"}
})

-- JSON
nvim_lsp.jsonls.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities,
    cmd = {'vscode-json-language-server', '--stdio'},
    filetypes = {"json", "jsonc"}
})

require("rust-tools").setup({
    server = {
        standalone = false,
        on_attach = on_attach,
        capabilities = capabilities
    },
    tools = { -- rust-tools options
        -- how to execute terminal commands
        -- options right now: termopen / quickfix
        executor = require("rust-tools.executors").termopen,
        -- callback to execute once rust-analyzer is done initializing the workspace
        -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
        on_initialized = nil,
        -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
        reload_workspace_from_cargo_toml = true,
        -- These apply to the default RustSetInlayHints command
        inlay_hints = {
            -- automatically set inlay hints (type hints)
            -- default: true
            auto = true,
            -- Only show inlay hints for the current line
            only_current_line = false,
            -- whether to show parameter hints with the inlay hints or not
            -- default: true
            show_parameter_hints = true,
            -- prefix for parameter hints
            -- default: "<-"
            parameter_hints_prefix = "<- ",
            -- prefix for all the other hints (type, chaining)
            -- default: "=>"
            other_hints_prefix = "❯ ",
            -- whether to align to the length of the longest line in the file
            max_len_align = false,
            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,
            -- whether to align to the extreme right or not
            right_align = false,
            -- padding from the right if right_align is true
            right_align_padding = 7,
            -- The color of the hints
            highlight = "Comment"
        },
    }
})

-- Flutter (Configures dartls)
require("flutter-tools").setup({
    ui = {border = "rounded"},
    decorations = {statusline = {app_version = false, device = true}},
    debugger = {enabled = false},
    closing_tags = {
        highlight = "Comment", -- highlight for the closing tag
        prefix = "❯ ", -- character to use for close tag e.g. > Widget
        enabled = true -- set to false to disable
    },
    dev_log = {
        open_cmd = "tabedit" -- command to use to open the log buffer
    },
    outline = {
        open_cmd = "30vnew", -- command to use to open the outline buffer
        auto_open = false -- if true this will open the outline automatically when it is first populated
    },
    lsp = {
        on_attach = function(...)
            local commands = require("flutter-tools.commands")
            vim.api.nvim_create_augroup("hotReload", {})
            -- Hotreload on save
            vim.api.nvim_create_autocmd("BufWritePost", {
                group = "hotReload",
                pattern = "*.dart",
                callback = function()
                    if not commands.is_running() then
                        vim.fn.execute(
                            [[!kill -SIGUSR1 $(pgrep -f "[f]lutter_tool.*run")]])
                    end
                end
            })
            -- Format on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = "hotReload",
                pattern = "*.dart",
                callback = function()
                    vim.lsp.buf.format({async = true})
                end
            })

            on_attach(...)
        end,
        capabilities = capabilities, -- e.g. lsp_status capabilities
        settings = {showTodos = true, completeFunctionCalls = true}
    }
})

-- Pyright
nvim_lsp.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {python = {analysis = {useLibraryCodeForTypes = true}}}
})

-- elixir-ls
nvim_lsp.elixirls.setup({
    cmd = {"/usr/lib/elixir-ls/language_server.sh"},
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {python = {analysis = {useLibraryCodeForTypes = true}}}
})

-- Init efm server
require("LSP.efm")
