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

return {

    -- Start Screen
    {
        "glepnir/dashboard-nvim",
        event = "VimEnter",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            local utils = require("telescope.utils")
            local footer = {}

            local function get_dashboard_git_status()
                local git_cmd = { "git", "status", "-s", "--", "." }
                local output = utils.get_os_command_output(git_cmd)
                return { "Git status:", unpack(output) }
            end

            local _, ret = utils.get_os_command_output({
                "git",
                "rev-parse",
                "--show-toplevel",
            }, vim.loop.cwd())

            if ret ~= 0 then
                local is_worktree = utils.get_os_command_output({
                    "git",
                    "rev-parse",
                    "--is-inside-work-tree",
                }, vim.loop.cwd())
                if is_worktree[1] == "true" then
                    footer = get_dashboard_git_status()
                else
                    footer = { "Not in a git directory" }
                end
            else
                footer = get_dashboard_git_status()
            end

            require("dashboard").setup({
                theme = "doom",
                config = {
                    header = custom_header,
                    center = {
                        -- TODO: Use correct mappings
                        {
                            icon = " ",
                            icon_hi = "Title",
                            desc = "New File",
                            desc_hi = "String",
                            key = "Leader n",
                            key_hi = "Number",
                            action = "newfile",
                        },
                        {
                            icon = " ",
                            icon_hi = "Title",
                            desc = "Find File",
                            desc_hi = "String",
                            key = "Ctrl f",
                            key_hi = "Number",
                            action = "lua telescopeGFiles(true)",
                        },
                        {
                            icon = " ",
                            icon_hi = "Title",
                            desc = "Find Word",
                            desc_hi = "String",
                            key = "Alt shift f",
                            key_hi = "Number",
                            action = "Telescope live_grep",
                        },
                    },
                    footer = footer, -- your footer
                },
                hide = {
                    statusline = false, -- hide statusline default is true
                    tabline = false, -- hide the tabline
                    winbar = false, -- hide winbar
                },
            })
        end,
    },
}
