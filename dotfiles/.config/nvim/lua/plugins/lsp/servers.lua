-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
local nvim_lsp = require("lspconfig")
local on_attach = require("plugins.lsp.on_attach")
local util = require("lspconfig/util")

local capabilities = get_lsp_capabilities()
local servers = {
    -- No configuration needed
    "vimls",
    "intelephense",
    "lemminx",
    "dockerls",
    "mesonlsp",
    "neocmake",
    "blueprint_ls",
    "zls",
    "glsl_analyzer",
}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        flags = { debounce_text_changes = 150 },
        capabilities = capabilities,
        root_dir = function(fname)
            return util.root_pattern("package.json", ".git")(fname) or util.path.dirname(fname)
        end,
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
                path = runtime_path,
            },
            hint = { enable = true },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                },
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                -- library = vim.api.nvim_get_runtime_file("", true)
            },
            telemetry = { enable = false },
            format = { enable = false },
        },
    },
})

-- LaTex

-- Okular as fallback previewer for texlab
local has_evince = vim.fn.executable("evince") == 1 and vim.fn.executable("evince-synctex") == 1
local evince_config = { "-f", "%l", "%p",
                        [[nvim-texlabconfig -file %f -line %l -server ]] .. vim.v.servername }
local okular_config = {
    "--unique",
    "file:%p#src:%l%f",
    "--editor-cmd",
    [[nvim-texlabconfig -file %f -line %l -server ]] .. vim.v.servername,
}
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
                onSave = true,
            },
            chktex = { onEdit = false, onOpenAndSave = false },
            diagnosticsDelay = 300,
            formatterLineLength = 80,
            forwardSearch = {
                executable = has_evince and "evince-synctex" or "okular",
                args = has_evince and evince_config or okular_config,
            },
            latexFormatter = "latexindent",
            latexindent = { modifyLineBreaks = false },
        },
    },
}

nvim_lsp.vala_ls.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
})

-- TypeScript/JavaScript
nvim_lsp.ts_ls.setup({
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
        "typescript.tsx",
    },
    init_options = {
        provideFormatter = false,
        hostInfo = "neovim",
        preferences = { includeCompletionsWithSnippetText = true,
                        includeCompletionsForImportStatements = true },
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
                includeInlayEnumMemberValueHints = true,
            },
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
                includeInlayEnumMemberValueHints = true,
            },
        },
    },
})

-- Biome: Web project toolchain
nvim_lsp.biome.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    cmd = { "biome", "lsp-proxy" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescript.tsx", "typescriptreact" },
    root_dir = util.root_pattern("biome.json"),
    single_file_support = false,
    default_config = { root_dir = [[root_pattern('biome.json')]] },
})

nvim_lsp.stylelint_lsp.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
})

nvim_lsp.emmet_language_server.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    root_dir = function(fname)
        return util.root_pattern("package.json", ".git")(fname) or util.path.dirname(fname)
    end,
    filetypes = {
        "css",
        "eruby",
        "html",
        "htmldjango",
        "javascriptreact",
        "less",
        "pug",
        "sass",
        "scss",
        "typescriptreact",
    },
})

-- CSharp
nvim_lsp.omnisharp.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
})

-- Clangd
nvim_lsp.clangd.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    cmd = { "clangd", "-fallback-style=Google" },
})

-- Bash
nvim_lsp.bashls.setup({
    on_attach = on_attach,
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh", "zsh", "bash" },
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
    filetypes = { "html", "heex", "blade" },
})

-- JSON
nvim_lsp.jsonls.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    init_options = { provideFormatter = false },
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
})

-- CSS LS
nvim_lsp.cssls.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        on_attach(client, bufnr)
    end,
    init_options = { provideFormatter = false },
    flags = { debounce_text_changes = 150 },
    capabilities = capabilities,
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
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
        inlay_hints = { auto = false },
    },
})

-- Flutter (Configures dartls)
require("flutter-tools").setup({
    ui = { border = "rounded" },
    decorations = { statusline = { app_version = false, device = true } },
    debugger = { enabled = false },
    closing_tags = {
        highlight = "Comment", -- highlight for the closing tag
        prefix = "❯ ", -- character to use for close tag e.g. > Widget
        enabled = true, -- set to false to disable
    },
    dev_log = {
        open_cmd = "tabedit", -- command to use to open the log buffer
    },
    outline = {
        open_cmd = "30vnew", -- command to use to open the outline buffer
        auto_open = false, -- if true this will open the outline automatically when it is first populated
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
                end,
            })
            -- Format on save
            vim.api.nvim_create_autocmd("BufWritePre",
                                        {
                group = "hotReload",
                pattern = "*.dart",
                callback = function() vim.lsp.buf.format({ async = true }) end,
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
            virtual_text_str = "■", -- the virtual text character to highlight
        },
        settings = {
            -- https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt", -- "always"
            enableSnippets = true,
            updateImportsOnRename = true, -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
            dart = { lineLength = 120 },
        },
    },
})

-- Pyright
nvim_lsp.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = { python = { analysis = { useLibraryCodeForTypes = true } } },
})

-- elixir-ls
nvim_lsp.elixirls.setup({
    cmd = { get_lsp_path("elixir-ls", "/usr/lib/elixir-ls/language_server.sh") },
    on_attach = on_attach,
    capabilities = capabilities,
})

-- GitHub Actions LSP
nvim_lsp.elixirls.setup({
    default_config = {
        cmd = { "gh-actions-language-server", "--stdio" },
        filetypes = { "yaml.github" },
        root_dir = util.root_pattern(".github"),
        single_file_support = true,
        capabilities = { workspace = { didChangeWorkspaceFolders = { dynamicRegistration = true } } },
    },
    docs = {
        description = [[
https://github.com/lttb/gh-actions-language-server
Language server for GitHub Actions.
`gh-actions-language-server` can be installed via `npm`:
```sh
npm install -g gh-actions-language-server
```
]],
    },
})

-- Java setup in ftplugins dir

-- Init efm server
require("plugins.lsp.efm")
