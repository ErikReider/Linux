local lsps = {
    -- LSPs
    { "vala-language-server", version = "HEAD" },
    "bash-language-server",
    "shellcheck",
    "efm",
    "clangd",
    "lua-language-server",
    "vim-language-server",
    -- Note: Rust uses rustaceanvim instead with the natively packaged analyzer
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
    "systemd-lsp",
    "ansible-language-server",
    "kotlin-lsp",
}

local linters = {
    -- Linters/Formatters
    "biome", -- Linter and formatter that replaces prettierd and eslint_d
    -- Linters
    -- TODO: Linters
    "vint",
    "markdownlint",
    "cpplint",
    "cspell",
    "actionlint",
    "systemdlint",
    "ansible-lint",
}

local formatters = {
    -- Formatters
    "stylua",
    "black",
    "shfmt",
    -- TODO: Prettierd Plugins https://github.com/fsouza/prettierd#additional-plugins
    "prettierd",
    "clang-format",
    "latexindent",
}

local daps = {
    "cppdbg",
    "elixir",
}

return {
    --
    -- Lsp Installer
    --
    {
        "williamboman/mason.nvim",
        opts = {},
    },
    -- Auto installs lsps
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        lazy = false,
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = {
            auto_update = false,
            -- a list of all tools you want to ensure are installed upon
            -- start; they should be the names Mason uses for each tool
            ensure_installed = {
                unpack(lsps),
                unpack(linters),
                unpack(formatters),
            },
        },
    },
    -- Auto installs DAP debuggers
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        -- TODO: Setup DAP properly
        opts = {
            -- A list of adapters to install if they're not already installed.
            -- This setting has no relation with the `automatic_installation` setting.
            -- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
            ensure_installed = daps,

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
            automatic_setup = false,
        },
    },
}
