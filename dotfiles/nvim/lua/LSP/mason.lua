local mason_dap = require("mason-nvim-dap")
local dap = require("dap")

require("mason").setup()

require("mason-tool-installer").setup({
    -- a list of all tools you want to ensure are installed upon
    -- start; they should be the names Mason uses for each tool
    ensure_installed = {
        -- LuaFormatter off

        -- LSPs
        { 'vala-language-server', version = "HEAD" },
        'bash-language-server',
        'shellcheck',
        'efm',
        'clangd',
        'lua-language-server',
        'vim-language-server',
        -- TODO: Use rust-tools
        'rust-analyzer',
        'css-lsp',
        'html-lsp',
        'json-lsp',
        'dockerfile-language-server',
        'emmet-ls',
        { 'elixir-ls', version = "v0.14.2" },
        'lemminx',
        'typescript-language-server',
        'stylelint-lsp',
        'pyright',
        'omnisharp',

        -- Linters
        -- TODO: Linters
        'vint',
        'markdownlint',
        'eslint_d',
        'cpplint',

        -- Formatters
        'luaformatter',
        'autopep8',
        'shfmt',
        -- TODO: Prettierd Plugins https://github.com/fsouza/prettierd#additional-plugins
        'prettierd',
        'clang-format',
        'rustfmt'

        -- LuaFormatter on
    },
    auto_update = false
})

mason_dap.setup({
    -- A list of adapters to install if they're not already installed.
    -- This setting has no relation with the `automatic_installation` setting.
    -- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
    ensure_installed = {"cppdbg", "elixir"},

    -- NOTE: this is left here for future porting in case needed
    -- Whether adapters that are set up (via dap) should be automatically installed if they're not already installed.
    -- This setting has no relation with the `ensure_installed` setting.
    -- Can either be:
    --   - false: Daps are not automatically installed.
    --   - true: All adapters set up via dap are automatically installed.
    --   - { exclude: string[] }: All adapters set up via mason-nvim-dap, except the ones provided in the list, are automatically installed.
    --       Example: automatic_installation = { exclude = { "python", "delve" } }
    automatic_installation = false,

    -- Whether adapters that are installed in mason should be automatically set up in dap.
    -- Removes the need to set up dap manually.
    -- See mappings.adapters and mappings.configurations for settings.
    -- Must invoke when set to true: `require 'mason-nvim-dap'.setup_handlers()`
    -- Can either be:
    -- 	- false: Dap is not automatically configured.
    -- 	- true: Dap is automatically configured.
    -- 	- {adapters: {ADAPTER: {}, }, configurations: {ADAPTER: {}, }}. Allows overriding default configuration.
    automatic_setup = false
})

-- local configs = {
--     cppdbg = 
-- }
--
-- mason_dap.setup_handlers({
--     cppdbg = function(_source_name)  end
-- })

