local util = require("lspconfig/util")

local lua_format = require("efmls-configs.formatters.lua_format")
local prettier = require("efmls-configs.formatters.prettier")
local biome_formatter = require("efmls-configs.formatters.biome")
local shfmt = require("plugins.lsp.Diagnostics.shfmt")

local efm_languages = {
    lua = { lua_format },
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
    javascript = { biome_formatter },
    javascriptreact = { biome_formatter },
    ["javascript.jsx"] = { biome_formatter },
    typescript = { biome_formatter },
    typescriptreact = { biome_formatter },
    ["typescript.tsx"] = { biome_formatter },
    python = { { formatCommand = "black --quiet -", formatStdin = true } }
    -- latex = {{}},
}
local efm_root_markers = { "package.json", "yarn.lock", "package-lock.json", ".git/", ".zshrc", "init.lua" }

return {
    filetypes = vim.tbl_keys(efm_languages),
    root_dir = util.root_pattern(unpack(efm_root_markers)),
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
        hover = true,
        documentSymbol = true,
        codeAction = true,
        completion = true
    },
    settings = { rootMarkers = efm_root_markers, languages = efm_languages }
}
