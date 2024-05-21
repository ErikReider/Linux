local nvim_lsp = require("lspconfig")

local prettier = require("plugins.lsp.Diagnostics.prettier")
local biome_formatter = require("plugins.lsp.Diagnostics.biome_formatter")
local shfmt = require("plugins.lsp.Diagnostics.shfmt")

local efm_languages = {
    lua = { { formatCommand = "lua-format -i", formatStdin = true } },
    sh = { shfmt },
    zsh = { shfmt },
    bash = { shfmt },
    -- Prettier
    yaml = { prettier },
    xml = { prettier },
    svg = { prettier },
    xsd = { prettier },
    xsl = { prettier },
    xslt = { prettier },
    markdown = {
        prettier,
        {
            lintCommand = "markdownlint -s",
            lintStdin = true,
            lintFormats = { "%f:%l %m", "%f:%l:%c %m", "%f: %l: %m" }
        }
    },
    jsonc = { prettier },
    json = { prettier },
    html = { prettier },
    htmldjango = { prettier },
    scss = { prettier },
    less = { prettier },
    sass = { prettier },
    css = { prettier },
    -- Biome
    javascript = {biome_formatter},
    javascriptreact = {biome_formatter},
    ["javascript.jsx"] = {biome_formatter},
    typescript = {biome_formatter},
    typescriptreact = {biome_formatter},
    ["typescript.tsx"] = {biome_formatter},
    python = { { formatCommand = "autopep8 --ignore E501 -", formatStdin = true } }
    -- latex = {{}},
}
local efm_root_markers = { "package.json", "yarn.lock", "package-lock.json", ".git/", ".zshrc" }
nvim_lsp.efm.setup({
    on_attach = require("plugins.lsp.on_attach"),
    flags = { debounce_text_changes = 150 },
    cmd = { "efm-langserver" },
    filetypes = vim.tbl_keys(efm_languages),
    root_dir = nvim_lsp.util.root_pattern(unpack(efm_root_markers)),
    init_options = {
        documentFormatting = true,
        hover = true,
        documentSymbol = true,
        codeAction = true,
        completion = true
    },
    settings = { rootMarkers = efm_root_markers, languages = efm_languages }
})
