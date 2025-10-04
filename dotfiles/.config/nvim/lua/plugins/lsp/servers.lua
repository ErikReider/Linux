-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
local util = require("lspconfig/util")

-- on_attach replacement
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            vim.print("Could not get client")
            return
        end

        require("illuminate").on_attach(client)

        if client:supports_method("textDocument/documentColor") then
            if vim.lsp["document_color"] then
                vim.lsp.document_color.enable(true, args.buf, { style = "virtual" })
            end
        end

        -- if client:supports_method("textDocument/inlayHint") then
        --     vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        -- end
    end,
})

local capabilities = _G.get_lsp_capabilities()
local servers = {
    -- ["example"] = {
    --     -- Append upon the on_attach function from lspconfig
    --     on_attach = ...,
    -- },

    -- VimScript language server.
    ["vimls"] = {},
    -- PHP
    ["intelephense"] = {},
    -- XML
    ["lemminx"] = {},
    -- Dockerfile
    ["dockerls"] = {},
    -- Meson
    ["mesonlsp"] = {},
    -- CMake LSP implementation based on Tower and Tree-sitter.
    ["neocmake"] = {},
    -- GTK Blueprint
    ["blueprint_ls"] = {},
    -- Zig
    ["zls"] = {},
    -- GLSL
    ["glsl_analyzer"] = {},
    -- Hyprland lsp
    ["hyprls"] = {},
    -- Yaml
    ["yamlls"] = {},
    -- Prolog: run `swipl pack install lsp_server`
    ["prolog_ls"] = {},
    -- GitHub actions
    ["gh_actions_ls"] = {},
    -- Lua
    ["lua_ls"] = {
        -- Copied from: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if
                    path ~= vim.fn.stdpath("config")
                    and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
                then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most
                    -- likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                    -- Tell the language server how to find Lua modules same way as Neovim
                    -- (see `:h lua-module-load`)
                    path = { "lua/?.lua", "lua/?/init.lua" },
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        -- Depending on the usage, you might want to add additional paths
                        -- here.
                        -- '${3rd}/luv/library'
                        -- '${3rd}/busted/library'
                    },
                    -- Or pull in all of 'runtimepath'.
                    -- NOTE: this is a lot slower and will cause issues when working on
                    -- your own configuration.
                    -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                    -- library = {
                    --   vim.api.nvim_get_runtime_file('', true),
                    -- }
                },
                telemetry = { enable = false },
                format = { enable = false },
            })
        end,
        -- NOTE: Needed to extend the config above
        settings = { Lua = {} },
        root_markers = {
            "init.lua",
            ".lua-format",
            ".luarc.json",
            ".luarc.jsonc",
            ".luacheckrc",
            ".stylua.toml",
            "stylua.toml",
            "selene.toml",
            "selene.yml",
            ".git",
        },
    },
    -- LaTex
    ["texlab"] = {
        on_init = function(client)
            -- Okular as fallback previewer for texlab
            local has_evince = vim.fn.executable("evince") == 1 and vim.fn.executable("evince-synctex") == 1
            local evince_config = {
                "-f",
                "%l",
                "%p",
                [[nvim-texlabconfig -file %f -line %l -server ]] .. vim.v.servername,
            }
            local okular_config = {
                "--unique",
                "file:%p#src:%l%f",
                "--editor-cmd",
                [[nvim-texlabconfig -file %f -line %l -server ]] .. vim.v.servername,
            }

            client.config.settings.texlab = vim.tbl_deep_extend("force", client.config.settings.texlab, {
                forwardSearch = {
                    executable = has_evince and "evince-synctex" or "okular",
                    args = has_evince and evince_config or okular_config,
                },
            })
        end,
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
                formatterLineLength = 80,
                latexFormatter = "latexindent",
                latexindent = { modifyLineBreaks = false },
            },
        },
    },
    -- Vala
    ["vala_ls"] = {},
    -- TypeScript/JavaScript
    ["ts_ls"] = {
        on_attach = function(client, bufnr)
            if client.config.flags then
                client.config.flags.allow_incremental_sync = true
            end
            client.server_capabilities.document_formatting = false
        end,
        init_options = {
            provideFormatter = false,
            hostInfo = "neovim",
            preferences = {
                includeCompletionsWithSnippetText = true,
                includeCompletionsForImportStatements = true,
            },
        },
    },
    -- JS/TS Linter: Biome, Web project toolchain
    ["biome"] = {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescript.tsx", "typescriptreact" },
        root_dir = util.root_pattern("biome.json"),
        single_file_support = false,
    },
    -- Stylelint: CSS linter
    ["stylelint_lsp"] = {
        on_attach = function(client, bufnr)
            client.server_capabilities.document_formatting = false
        end,
    },
    -- HTML "snippets": Emmet language server, A language server for emmet.io
    ["emmet_language_server"] = {},
    -- C#: TODO: Replace with csharp-language-server?
    ["omnisharp"] = {},
    -- Clangd
    ["clangd"] = {
        cmd = { "clangd", "-fallback-style=Google", "--clang-tidy" },
    },
    -- Bash
    ["bashls"] = {
        filetypes = { "sh", "zsh", "bash" },
    },
    -- HTML: vscode-html-language-server
    ["html"] = {
        on_attach = function(client, bufnr)
            client.server_capabilities.document_formatting = false
            client.server_capabilities.documentFormattingProvider = false
        end,
        filetypes = { "html", "templ", "heex", "blade" },
    },
    -- JSON: vscode-langservers-extracted
    ["jsonls"] = {
        on_attach = function(client, bufnr)
            client.server_capabilities.document_formatting = false
        end,
        init_options = { provideFormatter = false },
    },
    -- CSS: vscode-langservers-extracted
    ["cssls"] = {
        on_attach = function(client, bufnr)
            client.server_capabilities.document_formatting = false
        end,
        init_options = { provideFormatter = false },
    },
    -- Python: BasedPyright, Fork of pyright with various type checking improvements, pylance features...
    ["basedpyright"] = {},
    -- Elixir: elixir-ls
    ["elixirls"] = {
        cmd = { "elixir-ls" },
    },
    -- Java: jdtls
    ["jdtls"] = {},
    -- efm language server
    ["efm"] = require("plugins.lsp.efm"),

    -- Rust: Configured by the "mrcjkb/rustaceanvim" plugin automatically
    -- Flutter: Configured by the "nvim-flutter/flutter-tools.nvim" plugin below
}

-- Load the default config
vim.lsp.config("*", {
    root_markers = { ".git", "package.json" },
    capabilities = capabilities,
})
-- Load the extended configuration (if non-empty)
for name, value in pairs(servers) do
    if not vim.tbl_isempty(value) then
        -- Call the base on_attach from lspconfig and my own
        local base_on_attach = (vim.lsp.config[name] or {}).on_attach
        local new_on_attach = value.on_attach
        value.on_attach = function(client, bufnr)
            if base_on_attach then
                base_on_attach(client, bufnr)
            end
            if new_on_attach then
                new_on_attach(client, bufnr)
            end
        end

        vim.lsp.config(name, value)
    end
end
-- Enable all listed language servers
vim.lsp.enable(vim.tbl_keys(servers), true)

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
            -- Hot-reload on save
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
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = "hotReload",
                pattern = "*.dart",
                callback = function()
                    vim.lsp.buf.format({ async = true })
                end,
            })
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
