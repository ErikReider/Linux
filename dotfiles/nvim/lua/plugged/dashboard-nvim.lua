local db = require("dashboard")
db.hide_statusline = false
db.hide_tabline = false

db.custom_header = {
    "                                   ",
    "         ((##           (((        ",
    "       ((((###(         (((((      ",
    "    //*(((((((((        ((((((((   ",
    "    ////*(((((((((      ((((((((   ",
    "    ///////((((((((,    ////////   ",
    "    *******/(((((((((   ////////   ",
    "    ******** (((((((((( ////////   ",
    "    ********   (((((((((////////   ",
    "    ********     ///////////////   ",
    "    ********      //////////////   ",
    "    ********        /////////***   ",
    "       *****         ,///////      ",
    "         ,,,           ////        ", "", ""
}

db.custom_center = {
    {
        icon = " ",
        desc = "New File                  ",
        action = "DashboardNewFile",
        shortcut = "Leader n    "
    }, {
        icon = " ",
        desc = "Find File                 ",
        action = "lua telescopeGFiles(true)",
        shortcut = "Ctrl f      "
    }, {
        icon = " ",
        desc = "Find Word                 ",
        action = "Telescope live_grep",
        shortcut = "Alt shift f "
    }
}


local utils = require("telescope.utils")

local function get_dashboard_git_status()
    local git_cmd = {"git", "status", "-s", "--", "."}
    local output = utils.get_os_command_output(git_cmd)
    db.custom_footer = {"Git status:", unpack(output)}
end

local _, ret = utils.get_os_command_output({
    "git", "rev-parse", "--show-toplevel"
}, vim.loop.cwd())

if ret ~= 0 then
    local is_worktree = utils.get_os_command_output({
        "git", "rev-parse", "--is-inside-work-tree"
    }, vim.loop.cwd())
    if is_worktree[1] == "true" then
        get_dashboard_git_status()
    else
        db.custom_footer = {"Not in a git directory"}
    end
else
    get_dashboard_git_status()
end
