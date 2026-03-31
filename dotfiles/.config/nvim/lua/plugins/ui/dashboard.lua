---@module "lazy"

-- TODO: https://api.adviceslip.com/advice
local custom_header = {
    "",
    "  ________________________________ ",
    "/ It’s not a bug — it’s an       \\",
    "\\ undocumented feature.          /",
    "  -------------------------------- ",
    "        \\   ^__^                  ",
    "         \\  (oo)\\_______         ",
    "           (__)\\       )\\/\\     ",
    "                ||----w |          ",
    "                ||     ||          ",
    "",
    "",
}

-- local custom_header = {
--     "                                   ",
--     "         ((##           (((        ",
--     "       ((((###(         (((((      ",
--     "    //*(((((((((        ((((((((   ",
--     "    ////*(((((((((      ((((((((   ",
--     "    ///////((((((((,    ////////   ",
--     "    *******/(((((((((   ////////   ",
--     "    ******** (((((((((( ////////   ",
--     "    ********   (((((((((////////   ",
--     "    ********     ///////////////   ",
--     "    ********      //////////////   ",
--     "    ********        /////////***   ",
--     "       *****         ,///////      ",
--     "         ,,,           ////        ", "", ""
-- }

---@type LazySpec
return {
    -- Start Screen
    {
        "glepnir/dashboard-nvim",
        event = "VimEnter",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            theme = "doom",
            config = {
                vertical_center = true,
                project = { enable = false },
                mru = { enable = false },
                header = custom_header,
                center = {
                    {
                        icon = " ",
                        icon_hi = "Title",
                        desc = "Find File",
                        desc_hi = "String",
                        key = "Leader f",
                        key_hi = "Number",
                        action = "TelescopeGitFiles local",
                    },
                    {
                        icon = " ",
                        icon_hi = "Title",
                        desc = "Find Word",
                        desc_hi = "String",
                        key = "Leader s",
                        key_hi = "Number",
                        action = "Telescope live_grep",
                    },
                },
            },
            hide = {
                statusline = false,
                tabline = false,
                winbar = false,
            },
        },
    },
}
