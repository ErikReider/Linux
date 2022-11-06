local utils = require("telescope.utils")

-- Open F5 options
local f5RunOptions = {
    {
        filetypes = {
            "typescriptreact", "javascriptreact", "typescript", "javascript"
        },
        hasFiles = {"node_modules", "package.json", "package-lock.json"},
        run = "!npm start",
        build = "!npm run build"
    }, {filetypes = {"markdown"}, run = "MarkdownPreview"}
}
local function getRunAction()
    local ft = vim.api.nvim_buf_get_option(0, "filetype")
    local lines = io.popen('ls -a'):lines()
    for _, option in pairs(f5RunOptions) do
        local filetypes = option.filetypes == nil and {} or option.filetypes
        if table.maxn(filetypes) > 0 and tableContains(filetypes, ft) then
            local run = option.run == nil and "" or option.run
            local build = option.build == nil and "" or option.build
            local hasFiles = option.hasFiles == nil and {} or option.hasFiles
            if string.len(run) > 0 or string.len(build) > 0 then
                local foundFiles = {}
                for file in lines do
                    if tableContains(hasFiles, file) then
                        table.insert(foundFiles, file)
                    end
                end
                if table.maxn(hasFiles) == table.maxn(foundFiles) then
                    return {run = run, build = build}
                end
            end
        end
    end
    return {run = "", build = ""}
end

local function getF5Table()
    local f5Table = {
        {title = "Open PWD Folder", action = disownCMD("xdg-open .")},
        {title = "Open LazyDocker", action = "LazyDocker"},
        {title = "Open Terminal", action = disownCMD("$TERM")}
    }

    local currentFileFolderPath = vim.api.nvim_eval("expand('%:p:h')")
    if string.len(currentFileFolderPath) > 0 then
        table.insert(f5Table, 1, {
            title = "Open File Folder",
            action = disownCMD("xdg-open " .. currentFileFolderPath)
        })
    end

    local currentFilePath = vim.api.nvim_buf_get_name(0)
    if string.len(currentFilePath) > 0 then
        table.insert(f5Table, 1, {
            title = "Open File",
            action = disownCMD("xdg-open " .. currentFilePath)
        })

        -- Check if in Git directory
        local function add_file_in_browser()
            table.insert(f5Table, 2,
                         {title = "Open File In Browser", action = "GBrowse"})
        end
        local _, ret = utils.get_os_command_output({
            "git", "rev-parse", "--show-toplevel"
        }, vim.loop.cwd())

        if ret ~= 0 then
            local is_worktree = utils.get_os_command_output({
                "git", "rev-parse", "--is-inside-work-tree"
            }, vim.loop.cwd())
            if is_worktree[1] == "true" then add_file_in_browser() end
        else
            add_file_in_browser()
        end
    end

    local action = getRunAction()
    if string.len(action.build) > 0 then
        local text = "Build"
        if action.build:sub(0, 1) == "!" then
            action.build = runCmdInTerm(action.build, true)
            text = text .. " in terminal"
        end
        table.insert(f5Table, 1, {title = text, action = action.build})
    end
    if string.len(action.run) > 0 then
        local text = "Run"
        if action.run:sub(0, 1) == "!" then
            action.run = runCmdInTerm(action.run, true)
            text = text .. " in terminal"
        end
        table.insert(f5Table, 1, {title = text, action = action.run})
    end

    return f5Table
end

local Popup = require("floatingWindow")()

function _G.F5Show() Popup:show(getF5Table()) end

map("n", "<F5>", ":lua F5Show()<CR>", {noremap = true, silent = true})
