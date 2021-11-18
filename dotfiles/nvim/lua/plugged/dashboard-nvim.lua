vim.g.dashboard_custom_header = {
    "                .88888888:.", "               88888888.88888.",
    "             .8888888888888888.", "             888888888888888888",
    "             88' _`88'_  `88888", "             88 88 88 88  88888",
    "             88_88_::_88_:88888", "             88:::,::,:::::8888",
    "             88`:::::::::'`8888", "            .88  `::::'    8:88.",
    "           8888            `8:888.",
    "         .8888'             `888888.",
    "        .8888:..  .::.  ...:'8888888:.",
    "       .8888.'     :'     `'::`88:88888",
    "      .8888        '         `.888:8888.",
    "     888:8         .           888:88888",
    "   .888:88        .:           888:88888:",
    "   8888888.       ::           88:888888",
    "   `.::.888.      ::          .88888888",
    "  .::::::.888.    ::         :::`8888'.:.",
    " ::::::::::.888   '         .::::::::::::",
    " ::::::::::::.8    '      .:8::::::::::::.",
    ".::::::::::::::.        .:888:::::::::::::",
    ":::::::::::::::88:.__..:88888:::::::::::'",
    " `'.:::::::::::88888888888.88:::::::::'",
    "       `':::_:' -- '' -'-' `':_::::'`"
}

vim.highlight.create("DashboardHeader", {ctermfg = "white", guifg = "white"},
                     false)

vim.g.dashboard_custom_section = {
    a = {
        description = {" New File                  Leader n    "},
        command = "DashboardNewFile"
    },
    b = {
        description = {" Recent Files              Alt shift h "},
        command = "History"
    },
    c = {
        description = {" Open Last Session         Leader s l  "},
        command = "SessionLoad"
    },
    d = {
        description = {" Find File                 Ctrl f      "},
        command = "Files"
    },
    e = {
        description = {" Find Word                 Alt shift f "},
        command = "Rg"
    }
}

vim.g.dashboard_default_executive = "telescope"
vim.api.nvim_set_keymap("n", "<Leader>ss", ":<C-u>SessionSave<CR>", {})
vim.api.nvim_set_keymap("n", "<Leader>sl", ":<C-u>SessionLoad<CR>", {})
vim.api.nvim_set_keymap("n", "<Leader>n", ":DashboardNewFile<CR>",
                        {noremap = true, silent = true})

local utils = require('telescope.utils')
local set_var = vim.api.nvim_set_var

local _, ret = utils.get_os_command_output({
    "git", "rev-parse", "--show-toplevel"
}, vim.loop.cwd())

local function get_dashboard_git_status()
    local git_cmd = {'git', 'status', '-s', '--', '.'}
    local output = utils.get_os_command_output(git_cmd)
    set_var('dashboard_custom_footer', {'Git status', '', unpack(output)})
end

if ret ~= 0 then
    local is_worktree = utils.get_os_command_output({
        "git", "rev-parse", "--is-inside-work-tree"
    }, vim.loop.cwd())
    if is_worktree[1] == "true" then
        get_dashboard_git_status()
    else
        set_var('dashboard_custom_footer', {'Not in a git directory'})
    end
else
    get_dashboard_git_status()
end
