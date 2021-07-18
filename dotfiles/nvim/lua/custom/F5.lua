-- Open F5 options
local f5RunOptions = {
    {
        filetypes = {"typescriptreact", "javascriptreact", "lua"},
        runCMD = "npm start",
        buildCMD = "npm build"
    }
}
local function getRunAction()
    local filetype = vim.api.nvim_eval("&filetype")
    local val = {runCMD = "", buildCMD = ""}
    for _, tbl in pairs(f5RunOptions) do
        for _, ft in pairs(tbl.filetypes) do
            if ft == filetype then
                return {runCMD = tbl.runCMD, buildCMD = tbl.buildCMD}
            end
        end
    end
    return val
end
local function getF5Table()
    local f5Table = {{title = "Open Terminal", action = disownCMD("$TERM")}}
    local action = getRunAction()
    if action.buildCMD ~= "" then
        table.insert(f5Table, 1, {
            title = "Build in terminal",
            action = runCmdInTerm(action.buildCMD, true)
        })
    end
    if action.runCMD ~= "" then
        table.insert(f5Table, 1, {
            title = "Run in terminal",
            action = runCmdInTerm(action.runCMD, true)
        })
    end
    return f5Table
end

local popup = require("floatingWindow")()

function _G.F5Show() popup:show(getF5Table()) end

map("n", "<F5>", ":lua F5Show()<CR>", {noremap = true, silent = true})
