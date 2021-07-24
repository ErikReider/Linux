-- Open F5 options
local f5RunOptions = {
    {
        filetypes = {"typescriptreact", "javascriptreact"},
        hasFiles = {"node_modules", "package.json", "package-lock.json"},
        run = "npm start",
        runInTerminal = true,
        build = "npm run build",
        buildInTerminal = true
    }
}
local function getRunAction()
    local ft = vim.api.nvim_eval("&filetype")
    local val = {
        run = "",
        runInTerminal = false,
        build = "",
        buildInTerminal = false
    }
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
                    return {
                        run = run,
                        runInTerminal = option.runInTerminal == true,
                        build = build,
                        buildInTerminal = option.buildInTerminal == true
                    }
                end
            end
        end
    end
    return val
end

local function getF5Table()
    local f5Table = {
        {title = "Open Folder", action = disownCMD("xdg-open .")},
        {title = "Open Terminal", action = disownCMD("$TERM")}
    }

    local currentFilePath = vim.api.nvim_eval("expand('%:p')")
    if string.len(currentFilePath) > 0 then
        table.insert(f5Table, 1, {
            title = "Open File",
            action = disownCMD("xdg-open " .. currentFilePath)
        })
    end

    local action = getRunAction()
    if string.len(action.build) > 0 then
        if action.buildInTerminal then
            action.build = runCmdInTerm(action.build, true)
        end
        table.insert(f5Table, 1,
                     {title = "Build in terminal", action = action.build})
    end
    if string.len(action.run) > 0 then
        if action.runInTerminal then
            action.run = runCmdInTerm(action.run, true)
        end
        table.insert(f5Table, 1,
                     {title = "Run in terminal", action = action.run})
    end

    return f5Table
end

local Popup = require("floatingWindow")()

function _G.F5Show() Popup:show(getF5Table()) end

map("n", "<F5>", ":lua F5Show()<CR>", {noremap = true, silent = true})
