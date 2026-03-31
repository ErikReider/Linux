---@module "lazy"

-- NeoVim LSP
vim.lsp.log.set_level(vim.log.levels.WARN)
-- For debugging:
-- vim.lsp.log.set_level(vim.log.levels.DEBUG)

vim.diagnostic.config({
    -- Gutter diagnostic signs
    signs = {
        text = {
            -- [vim.diagnostic.severity.ERROR] = "❌",
            [vim.diagnostic.severity.ERROR] = "",
            -- [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.WARN] = "",
            -- [vim.diagnostic.severity.HINT] = "💡",
            [vim.diagnostic.severity.HINT] = "",
            -- [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.INFO] = "",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticLineNrError",
            [vim.diagnostic.severity.WARN] = "DiagnosticLineNrWarn",
            [vim.diagnostic.severity.HINT] = "DiagnosticLineNrHint",
            [vim.diagnostic.severity.INFO] = "DiagnosticLineNrInfo",
        },
    },
    -- disable virtual text
    virtual_text = false,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = true,
        style = "minimal",
        border = vim.o.winborder,
        source = true,
        header = "",
        prefix = "",
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            vim.print("Could not get client")
            return
        end

        require("illuminate").on_attach(client)

        -- Disable nvim-colorizer plugin highlighting for bufer if the attached
        -- LSP supports color highlighting.
        if client:supports_method("textDocument/documentColor") then
            if vim.lsp["document_color"] and vim.lsp.document_color.is_enabled() then
                vim.lsp.document_color.enable(true, { bufnr = args.buf }, { style = "virtual" })
                require("colorizer").detach_from_buffer(args.buf)
            end
        end

        -- Prefer LSP folding if client supports it
        if client:supports_method("textDocument/foldingRange") then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
        end

        -- if client:supports_method("textDocument/inlayHint") then
        --     vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        -- end
    end,
})

---@type LazySpec
return {
    ---@module "lspconfig"
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            -- Setup servers
            require("plugins.lsp.servers")
        end,
        dependencies = {
            {
                "creativenull/efmls-configs-nvim",
                version = "v1.x.x", -- version is optional, but recommended
            },
        },
    },
    {
        import = "plugins.lsp.mason",
    },
    {
        import = "plugins.lsp.dap",
    },
    {
        import = "plugins.lsp.language-plugins",
    },
    {
        import = "plugins.lsp.completions",
    },

    -- Vim plugin for automatically highlighting other uses of the word under the cursor.
    {
        "RRethy/vim-illuminate",
        main = "illuminate",
        config = function()
            require("illuminate").configure({
                filetypes_denylist = { "dirvish", "fugitive", "TelescopePrompt" },
            })
        end,
    },
    -- See LSP server startup status
    {
        "j-hui/fidget.nvim",
        opts = {
            -- Options related to notification subsystem
            notification = {
                -- Options related to the notification window and buffer
                window = {
                    avoid = { "NvimTree" }, -- Filetypes the notification window should avoid
                },
            },
        },
    },
}
