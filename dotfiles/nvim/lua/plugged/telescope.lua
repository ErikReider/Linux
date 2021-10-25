local utils = require('telescope.utils')
local tele = require("telescope.builtin")
local actions = require('telescope.actions')

local picker_options = {
    winblend = 20,
    theme = "dropdown",
    show_line = false,
    results_title = false,
    preview_title = false,
    prompt_prefix = "❯ ",
    selection_caret = "❯ "
}

require('telescope').setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
        }
    },
    pickers = {
        find_files = picker_options,
        git_files = picker_options,
        live_grep = picker_options,
        buffers = picker_options,
        oldfiles = picker_options,
        keymaps = picker_options,
        highlights = picker_options,
        lsp_workspace_diagnostics = picker_options,
        lsp_code_actions = {
            winblend = 20,
            theme = "cursor",
            show_line = false,
            results_title = false,
            preview_title = false
        }
    },
    defaults = {
        mappings = {
            i = {
                ["<C-h>"] = actions.which_key,
                ["<esc>"] = actions.close,
                ["<C-t>"] = actions.file_tab,
                ["<C-i>"] = actions.file_split,
                ["<C-s>"] = actions.file_vsplit,
                ["<C-Up>"] = actions.preview_scrolling_up,
                ["<C-Down>"] = actions.preview_scrolling_down,
                ["<S-Up>"] = function(nr)
                    for _ = 1, 5, 1 do
                        actions.move_selection_previous(nr)
                    end
                end,
                ["<S-Down>"] = function(nr)
                    for _ = 1, 5, 1 do
                        actions.move_selection_next(nr)
                    end
                end
            }
        }
    }
}

require('telescope').load_extension('fzf')

function _G.telescopeGFiles()
    local _, ret = utils.get_os_command_output({
        "git", "rev-parse", "--show-toplevel"
    }, vim.loop.cwd())
    local is_worktree = utils.get_os_command_output({
        "git", "rev-parse", "--is-inside-work-tree"
    }, vim.loop.cwd())

    if ret == 0 or is_worktree[1] == "true" then
        tele.git_files()
    else
        tele.find_files()
    end
end

local opts = {noremap = true, silent = true}
map("n", "<C-f>", [[<cmd>lua require("telescope.builtin").find_files()<CR>]],
    opts)
map("n", "<A-f>", [[<cmd>lua telescopeGFiles()<CR>]], opts)

map("n", "<A-S-f>", [[<cmd>lua require("telescope.builtin").live_grep()<CR>]],
    opts)
map("n", "<A-S-d>",
    [[<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find<CR>]],
    opts)
map("n", "<A-S-w>",
    [[<cmd>lua require("telescope.builtin").lsp_workspace_diagnostics()<CR>]],
    opts)
map("n", "<A-S-b>", [[<cmd>lua require("telescope.builtin").buffers()<CR>]],
    opts)
map("n", "<A-S-h>", [[<cmd>lua require("telescope.builtin").oldfiles()<CR>]],
    opts)
map("n", "<A-S-m>", [[<cmd>lua require("telescope.builtin").keymaps()<CR>]],
    opts)