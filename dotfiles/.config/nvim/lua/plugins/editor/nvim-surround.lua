---@module "lazy"

---@type LazySpec
return {
    ---@module "nvim-surround"
    {
        -- Add surrounding (), [], {}, etc...
        -- https://github.com/kylechui/nvim-surround
        "kylechui/nvim-surround",
        event = "VeryLazy",
        ---@type user_options
        opts = {
            -- Configuration here, or leave empty to use defaults
            aliases = {
                ["w"] = "{",
                ["s"] = "}",
                ["e"] = "(",
                ["d"] = ")",
                ["r"] = "[",
                ["f"] = "]",
                ["z"] = "&",
                ["x"] = "\\",
                ["c"] = "~",
                ["q"] = { "\"", "'", "`" },
                ["a"] = { "}", "]", ")", ">", "\"", "'", "`" },
            },
        },
    },
}
