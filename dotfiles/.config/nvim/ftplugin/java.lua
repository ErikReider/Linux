local nvim_lsp = require("lspconfig")
local on_attach = require("plugins.lsp.on_attach")
local util = require("lspconfig/util")

local capabilities = get_lsp_capabilities()

require('jdtls').start_or_attach({
    cmd = { get_lsp_path("jdtls", "") },
    on_attach = on_attach,
    capabilities = capabilities
})
