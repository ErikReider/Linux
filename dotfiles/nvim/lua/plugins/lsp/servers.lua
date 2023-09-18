-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
local nvim_lsp = require("lspconfig")
local on_attach = require("plugins.lsp.on_attach")
local util = require("lspconfig/util")

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- For nvim-ufo
capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
local servers = {
    -- No configuration needed
    "vimls",
    "cssls",
    "intelephense",
    "lemminx",
    "dockerls"
}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        flags = { debounce_text_changes = 150 },
        capabilities = capabilities
    }
end

-- Lua
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
nvim_lsp.lua_ls.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    cmd = { "lua-language-server" },
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- Setup your lua path
                path = runtime_path
            },
            hint = { enable = true },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" }
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false
            },
            telemetry = { enable = false },
            format = { enable = false }
        }
    }
})

nvim_lsp.texlab.setup {
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    settings = {
        texlab = {
            auxDirectory = ".",
            bibtexFormatter = "texlab",
            build = {
                args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                executable = "latexmk",
                forwardSearchAfter = true,
                onSave = true
            },
            chktex = { onEdit = false, onOpenAndSave = false },
            diagnosticsDelay = 300,
            formatterLineLength = 80,
            forwardSearch = {
                executable = "evince-synctex",
                args = {
                    "-f",
                    "%l",
                    "%p",
                    [[nvim-texlabconfig -file %f -line %l -server ]] .. vim.v.servername
                }
            },
            latexFormatter = "latexindent",
            latexindent = { modifyLineBreaks = false }
        }
    }
}

nvim_lsp.vala_ls.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities
})

-- TypeScript/JavaScript
nvim_lsp.tsserver.setup({
    on_attach = function(client, bufnr)
        if client.config.flags then client.config.flags.allow_incremental_sync = true end
        client.server_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx"
    },
    init_options = {
        hostInfo = "neovim",
        preferences = { includeCompletionsWithSnippetText = true, includeCompletionsForImportStatements = true }
    },
    settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true
            }
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true
            }
        }
    }
})

nvim_lsp.stylelint_lsp.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities
})

nvim_lsp.emmet_ls.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    root_dir = function(fname)
        return util.root_pattern("package.json", ".git")(fname) or util.path.dirname(fname)
    end,
    filetypes = {
        "html",
        "typescriptreact",
        "javascriptreact",
        "css",
        "sass",
        "scss",
        "less",
        "heex",
        "htmldjango"
    }
})

-- CSharp
nvim_lsp.omnisharp.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }
})

-- Clangd
nvim_lsp.clangd.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    cmd = { "clangd", "-fallback-style=Google" }
})

-- Bash
nvim_lsp.bashls.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh", "zsh", "bash" }
})

-- HTML
nvim_lsp.html.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        client.server_capabilities.documentFormattingProvider = false
        on_attach(client, bufnr)
    end,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html", "heex" }
})

-- JSON
nvim_lsp.jsonls.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" }
})

require("rust-tools").setup({
    server = { standalone = false, on_attach = on_attach, capabilities = capabilities },
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
        inlay_hints = { auto = false }
    }
})

-- Flutter (Configures dartls)
require("flutter-tools").setup({
    ui = { border = "rounded" },
    decorations = { statusline = { app_version = false, device = true } },
    debugger = { enabled = false },
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
                        vim.fn.execute([[!kill -SIGUSR1 $(pgrep -f "[f]lutter_tool.*run")]])
                    end
                end
            })
            -- Format on save
            vim.api.nvim_create_autocmd("BufWritePre",
                                        {
                group = "hotReload",
                pattern = "*.dart",
                callback = function() vim.lsp.buf.format({ async = true }) end
            })

            on_attach(...)
        end,
        capabilities = capabilities, -- e.g. lsp_status capabilities
        color = { -- show the derived colours for dart variables
            enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
            background = false, -- highlight the background
            background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
            foreground = false, -- highlight the foreground
            virtual_text = true, -- show the highlight using virtual text
            virtual_text_str = "■" -- the virtual text character to highlight
        },
        settings = {
            -- https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt", -- "always"
            enableSnippets = true,
            updateImportsOnRename = true, -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
            dart = { lineLength = 120 }
        }
    }
})

-- Pyright
nvim_lsp.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = { python = { analysis = { useLibraryCodeForTypes = true } } }
})

-- elixir-ls
nvim_lsp.elixirls.setup({
    cmd = { get_lsp_path("elixir-ls", "/usr/lib/elixir-ls/language_server.sh") },
    on_attach = on_attach,
    capabilities = capabilities
})

-- Init efm server
require("plugins.lsp.efm")
