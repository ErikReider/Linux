local utils = require("telescope.utils")

local runOptions = {
    {
        filetypes = { "typescriptreact", "javascriptreact", "typescript", "javascript" },
        hasFiles = { "node_modules", "package.json", "package-lock.json" },
        run = "!npm start",
        build = "!npm run build",
    },
    { filetypes = { "markdown" }, run = "PeekOpenOrClose" },
    { filetypes = { "tex" }, run = "TexlabBuild" },
}
local function getRunAction()
    local lines = io.popen("ls -a"):lines()
    for _, option in pairs(runOptions) do
        local filetypes = option.filetypes == nil and {} or option.filetypes
        if table.maxn(filetypes) > 0 and tableContains(filetypes, vim.bo.filetype) then
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
                    return { run = run, build = build }
                end
            end
        end
    end
    return { run = "", build = "" }
end

local Module = {}

function Module.getOptionsTable()
    local optionsTable = {
        { title = "Open PWD Folder", action = disownCMD("xdg-open .") },
        { title = "Change indentation style", action = "lua _G.show_indentation_popup()" },
        { title = "Open LazyDocker", action = "LazyDocker" },
        { title = "Search for TODOs", action = "TodoTelescope" },
        { title = "Toggle inactive shade", action = "lua require('shade').toggle()" },
        { title = "Edit color", action = "CccPick" },
        { title = "Toggle Debug Windows", action = "DapUiToggleWindows" },
    }

    -- Switch between C/C++ Header and Implementation files
    for _, value in ipairs({ "c", "h", "cpp", "hpp" }) do
        if vim.bo.filetype == value then
            table.insert(
                optionsTable,
                { title = "Open Header/Implementation file", action = "ClangdSwitchSourceHeader" }
            )
            break
        end
    end

    local currentFileFolderPath = vim.api.nvim_eval("expand('%:p:h')")
    if string.len(currentFileFolderPath) > 0 then
        table.insert(
            optionsTable,
            1,
            { title = "Open File Folder", action = disownCMD("xdg-open " .. currentFileFolderPath) }
        )
    end

    local currentFilePath = vim.api.nvim_buf_get_name(0)
    if string.len(currentFilePath) > 0 then
        table.insert(
            optionsTable,
            1,
            { title = "Open File", action = disownCMD("xdg-open " .. currentFilePath) }
        )

        -- Check if in Git directory
        local function add_file_in_browser()
            table.insert(optionsTable, 2, { title = "Open File In Browser", action = "GBrowse" })
        end
        local _, ret = utils.get_os_command_output({ "git", "rev-parse", "--show-toplevel" }, vim.loop.cwd())

        if ret ~= 0 then
            local is_worktree =
                utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" }, vim.loop.cwd())
            if is_worktree[1] == "true" then
                add_file_in_browser()
            end
        else
            add_file_in_browser()
        end
    end

    -- Open Cargo.tml
    -- local has_cargo = require'rust-tools'.open_cargo_toml.open_cargo_toml() ~= nil

    -- Launch Debug
    if vim.fn.filereadable(".vscode/launch.json") == 1 then
        require("dap.ext.vscode").load_launchjs()
        table.insert(optionsTable, 1, { title = "Debug", action = "Telescope dap configurations" })
    end

    local action = getRunAction()
    if string.len(action.build) > 0 then
        local text = "Build"
        if action.build:sub(0, 1) == "!" then
            action.build = runCmdInTerm(action.build, true)
            text = text .. " in terminal"
        end
        table.insert(optionsTable, 1, { title = text, action = action.build })
    end
    if string.len(action.run) > 0 then
        local text = "Run"
        if action.run:sub(0, 1) == "!" then
            action.run = runCmdInTerm(action.run, true)
            text = text .. " in terminal"
        end
        table.insert(optionsTable, 1, { title = text, action = action.run })
    end

    return optionsTable
end

-- Open options window
function Module.show()
    showFloatingMenu(Module.getOptionsTable())
end

return Module
