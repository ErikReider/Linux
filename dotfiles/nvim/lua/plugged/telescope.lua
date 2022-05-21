local actions = require('telescope.actions')

local picker_options = {
    winblend = 20,
    theme = "dropdown",
    show_line = false,
    results_title = false,
    preview_title = false,
    prompt_prefix = "❯ ",
    selection_caret = "❯ ",
    no_ignore = true
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
        find_files = tableMerge(picker_options, {
            find_command = { "rg", "--hidden", "--files", "--no-ignore" }
        }),
        git_files = tableMerge(picker_options, { use_git_root = true }),
        live_grep = picker_options,
        buffers = picker_options,
        oldfiles = picker_options,
        keymaps = picker_options,
        highlights = picker_options,
        lsp_workspace_diagnostics = picker_options,
        lsp_references = picker_options,
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
                ["<C-u>"] = false,
                ["<Tab>"] = actions.select_tab,
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

function _G.telescopeGFiles(local_dir)
    local opts = { use_git_root = not local_dir }
    local ok = pcall(require("telescope.builtin").git_files, opts)
    if not ok then require("telescope.builtin").find_files() end
end

local opts = { noremap = true, silent = true }
-- Git files CWD
map("n", "<C-f>", [[<cmd>lua telescopeGFiles(true)<CR>]], opts)
-- Git files git-root
map("n", "<A-d>", [[<cmd>lua telescopeGFiles(false)<CR>]], opts)
-- All CWD files
map("n", "<A-f>", [[<cmd>lua require("telescope.builtin").find_files()<CR>]], opts)
-- Search for string inside of all files in CWD
map("n", "<A-S-f>", [[<cmd>lua require("telescope.builtin").live_grep()<CR>]], opts)
-- Search for string inside buffer
map("n", "<A-S-d>", [[<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>]], opts)
-- Search for open buffers
map("n", "<A-S-b>", [[<cmd>lua require("telescope.builtin").buffers()<CR>]], opts)
-- Lists previously open files
map("n", "<A-S-h>", [[<cmd>lua require("telescope.builtin").oldfiles()<CR>]], opts)
-- Lists normal mode keymappings
map("n", "<A-S-m>", [[<cmd>lua require("telescope.builtin").keymaps()<CR>]], opts)
