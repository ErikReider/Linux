-- Comments
return {
    {
        "numToStr/Comment.nvim",
        enabled = true,
        dependencies = { "nvim-treesitter/nvim-treesitter", "JoosepAlviste/nvim-ts-context-commentstring" },
        opts = {
            ---Add a space b/w comment and the line
            padding = true,
            ---Whether the cursor should stay at its position
            sticky = true,
            ---Lines to be ignored while (un)comment
            ignore = nil,
            ---Enable keybindings
            ---NOTE: If given `false` then the plugin won't create any mappings
            mappings = {
                basic = false,
                extra = false,
            },
            ---Function to call before (un)comment
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            ---Function to call after (un)comment
            post_hook = nil,
        },
    },
}
