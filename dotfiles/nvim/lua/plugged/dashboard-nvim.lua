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

vim.g.dashboard_default_executive = "fzf"
vim.api.nvim_set_keymap("n", "<Leader>ss", ":<C-u>SessionSave<CR>", {})
vim.api.nvim_set_keymap("n", "<Leader>sl", ":<C-u>SessionLoad<CR>", {})
vim.api.nvim_set_keymap("n", "<Leader>n", ":DashboardNewFile<CR>",
                        {noremap = true, silent = true})
