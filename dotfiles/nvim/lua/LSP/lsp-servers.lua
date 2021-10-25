-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
local nvim_lsp = require('lspconfig')
local on_attach = require("LSP.on_attach")
local util = require("lspconfig/util")

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
local servers = {
    -- No configuration needed
    "vimls", "vala_ls", "dartls", "cssls", "texlab", "pyright", "clangd"
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
            telemetry = {enable = false}
        }
    }
})

-- TypeScript/JavaScript
nvim_lsp.tsserver.setup({
    on_attach = function(client, bufnr)
        if client.config.flags then
            client.config.flags.allow_incremental_sync = true
        end
        client.resolved_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities,
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
        client.resolved_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities
})

nvim_lsp.emmet_ls.setup({
    on_attach = on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities,
    -- root_dir = util.root_pattern('./', '.git')
    root_dir = function(fname)
        return util.root_pattern('package.json', '.git')(fname) or
                   util.path.dirname(fname)
    end
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
    on_attach = on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities,
    cmd = {"vscode-html-language-server", "--stdio"}
})

-- JSON
nvim_lsp.jsonls.setup({
    on_attach = on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities,
    cmd = {'vscode-json-language-server', '--stdio'},
    settings = {
        json = {
            -- Schemas https://www.schemastore.org
            schemas = {
                {
                    fileMatch = {"package.json"},
                    url = "https://json.schemastore.org/package.json"
                }, {
                    fileMatch = {"tsconfig*.json"},
                    url = "https://json.schemastore.org/tsconfig.json"
                }, {
                    fileMatch = {
                        ".prettierrc", ".prettierrc.json",
                        "prettier.config.json"
                    },
                    url = "https://json.schemastore.org/prettierrc.json"
                }, {
                    fileMatch = {".eslintrc", ".eslintrc.json"},
                    url = "https://json.schemastore.org/eslintrc.json"
                }, {
                    fileMatch = {
                        ".babelrc", ".babelrc.json", "babel.config.json"
                    },
                    url = "https://json.schemastore.org/babelrc.json"
                },
                {
                    fileMatch = {"lerna.json"},
                    url = "https://json.schemastore.org/lerna.json"
                }, {
                    fileMatch = {"now.json", "vercel.json"},
                    url = "https://json.schemastore.org/now.json"
                }, {
                    fileMatch = {
                        ".stylelintrc", ".stylelintrc.json",
                        "stylelint.config.json"
                    },
                    url = "http://json.schemastore.org/stylelintrc.json"
                }
            }
        }
    }
})

nvim_lsp.rust_analyzer.setup({
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            assist = {importGranularity = "module", importPrefix = "by_self"},
            cargo = {loadOutDirsFromCheck = true},
            procMacro = {enable = true}
        }
    }
})

-- Init efm server
require("LSP.efm")