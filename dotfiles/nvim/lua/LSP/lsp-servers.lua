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
    "vimls", "cssls", "texlab", "intelephense"
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

nvim_lsp.vala_ls.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities,
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
    on_attach = on_attach,
    flags = {debounce_text_changes = 150},
    capabilities = capabilities,
    cmd = {"vscode-html-language-server", "--stdio"}
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
    filetypes = {"json", "jsonc"},
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
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            assist = {importGranularity = "module", importPrefix = "by_self"},
            cargo = {loadOutDirsFromCheck = true},
            procMacro = {enable = true}
        }
    }
})

-- Flutter
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
                    vim.lsp.buf.format({ async = true })
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
    settings = {
        python = {
            analysis = {
                useLibraryCodeForTypes = true
            }
        }
    }
})

-- Init efm server
require("LSP.efm")

