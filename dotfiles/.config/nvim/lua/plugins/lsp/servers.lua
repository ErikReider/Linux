-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
local lsp_util = require("lspconfig/util")
local utils = require("utils")

local capabilities = utils.get_lsp_capabilities()

---@type string[]
local servers_disable = {
    "dartls",
}

---@type { [string]: vim.lsp.Config|(fun():vim.lsp.Config)|nil }
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
        ---@type lspconfig.settings.lua_ls
        settings = {
            Lua = {
                runtime = {
                    path = {
                        "lua/?.lua",
                        "lua/?/init.lua",

                        "?.lua",
                        "?/init.lua",
                        vim.fn.expand("~/.luarocks/share/lua/5.?/?.lua"),
                        vim.fn.expand("~/.luarocks/share/lua/5.?/?/init.lua"),
                        "/usr/share/5.?/?.lua",
                        "/usr/share/lua/5.?/?/init.lua",
                    },
                },
                telemetry = { enable = false },
                format = { enable = false },
            },
        },
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
    ["texlab"] = function()
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

        ---@type vim.lsp.Config
        return {
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
                    forwardSearch = {
                        executable = has_evince and "evince-synctex" or "okular",
                        args = has_evince and evince_config or okular_config,
                    },
                    latexFormatter = "latexindent",
                    latexindent = { modifyLineBreaks = false },
                },
            },
        }
    end,
    -- Vala
    ["vala_ls"] = {},
    -- TypeScript/JavaScript
    ["ts_ls"] = {
        on_attach = function(client, _)
            if client.config.flags then
                client.config.flags.allow_incremental_sync = true
            end
            client.server_capabilities.document_formatting = false
            client.server_capabilities.documentFormattingProvider = false
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
        root_dir = lsp_util.root_pattern("biome.json"),
        single_file_support = false,
    },
    -- Stylelint: CSS linter
    ["stylelint_lsp"] = {
        on_attach = function(client, _)
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
        filetypes = require("filetypes")["sh"],
    },
    -- HTML: vscode-html-language-server
    ["html"] = {
        on_attach = function(client, _)
            client.server_capabilities.document_formatting = false
            client.server_capabilities.documentFormattingProvider = false
        end,
        filetypes = { "html", "templ", "heex", "blade" },
    },
    -- JSON: vscode-langservers-extracted
    ["jsonls"] = {
        on_attach = function(client, _)
            client.server_capabilities.document_formatting = false
        end,
        init_options = { provideFormatter = false },
    },
    -- CSS: vscode-langservers-extracted
    ["cssls"] = {
        on_attach = function(client, _)
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
    -- Swift: included in the swift RPM package
    ["sourcekit"] = {
        filetypes = { "swift", "objc", "objcpp" },
    },
    -- Ansible
    ["ansiblels"] = {},
    -- Systemd LSP
    ["systemd_lsp"] = {},
    -- QT QML
    ["qmlls"] = {},
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
for name, server_cfg in pairs(servers) do
    ---@type vim.lsp.Config
    local config = {}
    if type(server_cfg) == "function" and vim.is_callable(server_cfg) then
        config = server_cfg()
    elseif type(server_cfg) == "table" then
        config = server_cfg
    end
    if vim.tbl_isempty(config) then
        goto continue
    end

    -- Merge overridden functions with base lsp_config functions
    for field, value in pairs(config) do
        ---@type function?
        local base_func = (vim.lsp.config[name] or {})[field]
        if vim.is_callable(value) and vim.is_callable(base_func) then
            config[field] = function(...)
                if base_func then
                    base_func(...)
                end
                if value then
                    value(...)
                end
            end
        end
    end

    vim.lsp.config(name, config)

    ::continue::
end

-- Enable all listed language servers
vim.lsp.enable(vim.tbl_keys(servers), true)
vim.lsp.enable(servers_disable, false)
