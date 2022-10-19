require("mason").setup()

require('mason-tool-installer').setup {
  -- a list of all tools you want to ensure are installed upon
  -- start; they should be the names Mason uses for each tool
  ensure_installed = {
    -- you can turn off/on auto_update per tool
    -- LSPs
    'vala-language-server',
    'bash-language-server',
    'shellcheck',
    'efm',
    'lua-language-server',
    'vim-language-server',
    -- TODO: Use rust-tools
    'rust-analyzer',
    'css-lsp',
    'html-lsp',
    'json-lsp',
    'dockerfile-language-server',
    'emmet-ls',
    'elixir-ls',
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
  },
  auto_update = false,
}

vim.api.nvim_create_autocmd('User', {
    pattern = 'MasonToolsUpdateCompleted',
    callback = function()
        vim.schedule(function()
            print 'mason-tool-installer has finished'
        end)
    end,
})
