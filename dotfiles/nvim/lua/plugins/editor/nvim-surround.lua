-- Add surrounding (), [], {}, etc...
return {
    {
        "kylechui/nvim-surround",
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
                ["a"] = { "}", "]", ")", ">", "\"", "'", "`" }
            }
        }
    }
}

