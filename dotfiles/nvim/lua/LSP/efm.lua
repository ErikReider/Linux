local nvim_lsp = require('lspconfig')

local prettier = require("LSP.Diagnostics.prettier")
local eslint = require("LSP.Diagnostics.eslint")
local uncrustify = require("LSP.Diagnostics.uncrustify")
local shfmt = require("LSP.Diagnostics.shfmt")

local efm_languages = {
    lua = {
        {formatCommand = "lua-format -i", formatStdin = true, lintSeverity = 2}
    },
    sh = {shfmt},
    zsh = {shfmt},
    bash = {shfmt},
    yaml = {prettier},
    markdown = {
        prettier, {
            lintCommand = "markdownlint -s",
            lintStdin = true,
            lintFormats = {"%f:%l %m", "%f:%l:%c %m", "%f: %l: %m"}
        }
    },
    javascript = {eslint, prettier},
    javascriptreact = {eslint, prettier},
    ["javascript.jsx"] = {eslint, prettier},
    typescript = {eslint, prettier},
    typescriptreact = {eslint, prettier},
    ["typescript.tsx"] = {eslint, prettier},
    jsonc = {prettier},
    json = {prettier},
    html = {prettier},
    scss = {prettier},
    css = {prettier},
    vala = {uncrustify.init("VALA")},
    python = {{formatCommand = "autopep8 --ignore E501 -", formatStdin = true}}
    -- latex = {{}},
}
local efm_root_markers = {
    "package.json", "yarn.lock", "package-lock.json", ".git/", ".zshrc",
    ".uncrustify.cfg"
}
nvim_lsp.efm.setup({
    on_attach = require("LSP.on_attach"),
    flags = {debounce_text_changes = 150},
    capabilities = (function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        return require('cmp_nvim_lsp').update_capabilities(capabilities)
    end)(),
    cmd = {"efm-langserver"},
    filetypes = vim.tbl_keys(efm_languages),
    root_dir = nvim_lsp.util.root_pattern(unpack(efm_root_markers)),
    init_options = {
        documentFormatting = true,
        hover = true,
        documentSymbol = true,
        codeAction = true,
        completion = true
    },
    settings = {rootMarkers = efm_root_markers, languages = efm_languages}
})
