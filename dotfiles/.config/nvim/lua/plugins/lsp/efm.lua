local biome_formatter = require("efmls-configs.formatters.biome")
local black_format = require("efmls-configs.formatters.black")
local markdown_lint = require("efmls-configs.linters.markdownlint")
local prettier = require("efmls-configs.formatters.prettier")
local shfmt = require("plugins.lsp.Diagnostics.shfmt")
local stylua = require("efmls-configs.formatters.stylua")

local efm_languages = {
    lua = { stylua },
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
    markdown = { prettier, markdown_lint },
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
    python = { black_format },
}

return {
    filetypes = vim.tbl_keys(efm_languages),
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
        hover = true,
        documentSymbol = true,
        codeAction = true,
        completion = true,
    },
    settings = { languages = efm_languages },
}
