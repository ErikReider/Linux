---@module "lazy"

---@type LazySpec
return {
    ---@module "lastplace"
    {
        -- Nvim plugin that intelligently reopens files at your last edit position.
        -- https://github.com/nxhung2304/lastplace.nvim
        "nxhung2304/lastplace.nvim",
        lazy = false,
        opts = {
            -- Filetypes to ignore
            ignore_filetypes = { "gitcommit", "gitrebase", "svn", "hgcommit" },
            -- Buffer types to ignore
            ignore_buftypes = { "quickfix", "nofile", "help" },
            -- Open folds after jumping
            open_folds = true,
        },
    },
}
