return {
    -- a list of all tools you want to ensure are installed upon
    -- start; they should be the names Mason uses for each tool
    ensure_installed = {
        -- LSPs
        { "vala-language-server", version = "HEAD" },
        "bash-language-server",
        "shellcheck",
        "efm",
        "clangd",
        "lua-language-server",
        "vim-language-server",
        -- TODO: Use rust-tools
        "rust-analyzer",
        "css-lsp",
        "html-lsp",
        "json-lsp",
        "dockerfile-language-server",
        "emmet-language-server",
        "elixir-ls",
        "lemminx",
        "typescript-language-server",
        "stylelint-lsp",
        "basedpyright",
        "omnisharp",
        "texlab",
        "jdtls",
        "mesonlsp",
        "neocmakelsp",
        "zls",
        "glsl_analyzer",
        "intelephense",
        "gh-actions-language-server",
        "hyprls",
        "yaml-language-server",

        -- Linters/Formatters
        "biome", -- Linter and formatter that replaces prettierd and eslint_d
        -- Linters
        -- TODO: Linters
        "vint",
        "markdownlint",
        "cpplint",
        "cspell",

        -- Formatters
        "luaformatter",
        "black",
        "shfmt",
        -- TODO: Prettierd Plugins https://github.com/fsouza/prettierd#additional-plugins
        "prettierd",
        "clang-format",
        "latexindent",
    },
    auto_update = false,
}
