---@module "lazy"

-- Comments
local c_comment_string = { "// %s", "/* %s */" }

---@type LazySpec
return {
    ---@module "ts-comments"
    {
        -- Tiny plugin to enhance Neovim's native comments
        -- https://github.com/folke/ts-comments.nvim
        "folke/ts-comments.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = "VeryLazy",
        enabled = vim.fn.has("nvim-0.10.0") == 1,
        ---@type TSCommentsOptions
        opts = {
            -- TODO: More comment strings from:
            -- https://github.com/numToStr/Comment.nvim/blob/e30b7f2008e52442154b66f7c519bfd2f1e32acb/lua/Comment/ft.lua#L41
            -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring/blob/1b212c2eee76d787bbea6aa5e92a2b534e7b4f8f/lua/ts_context_commentstring/config.lua#L63
            lang = {
                c = c_comment_string,
                cpp = c_comment_string,
                csharp = c_comment_string,
                java = c_comment_string,
                vala = c_comment_string,
                glsl = c_comment_string,
                blueprint = c_comment_string,
                asm = "# %s",
            },
        },
    },
}
