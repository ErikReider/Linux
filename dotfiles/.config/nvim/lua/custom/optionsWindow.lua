local utils = require("utils")

---@class OptionsWindowRunOptions
---@field filetypes table?
---@field hasFiles table?
---@field run string|function?
---@field preview string|function?
---@field build string|function?

---@type OptionsWindowRunOptions[]
local runOptions = {
    {
        filetypes = { "typescriptreact", "javascriptreact", "typescript", "javascript" },
        hasFiles = { "node_modules", "package.json", "package-lock.json" },
        run = function()
            utils.run_cmd_in_term({ "npm", "start" })
        end,
        build = function()
            utils.run_cmd_in_term({ "npm", "run", "build" })
        end,
    },
    {
        filetypes = { "markdown" },
        preview = "PeekOpenOrClose",
    },
    {
        filetypes = require("filetypes")["latex"],
        preview = "LspTexlabForward",
        build = "LspTexlabBuild",
    },
}
---@return OptionsWindowRunOptions?
local function getRunAction()
    local files = vim.fs.dir(vim.fs.normalize(vim.fn.getcwd()))
    for _, option in pairs(runOptions) do
        local filetypes = option.filetypes or {}
        local hasFiles = option.hasFiles or {}
        local run = option.run == "" and nil or option.run
        local preview = option.preview == "" and nil or option.preview
        local build = option.build == "" and nil or option.build
        if
            not utils.tbl_is_empty(filetypes)
            and vim.list_contains(filetypes, vim.bo.filetype)
            and (run or preview or build)
        then
            if hasFiles == {} then
                return option
            else
                -- Make sure the required files exist
                local foundFiles = {}
                for filename, type in files do
                    if type == "file" and vim.tbl_contains(hasFiles, filename) then
                        table.insert(foundFiles, filename)
                    end
                end
                if vim.tbl_count(hasFiles) == vim.tbl_count(foundFiles) then
                    return option
                end
            end
        end
    end
    return nil
end

local Module = {}

---@return FloatingWindowItem[]
function Module.getOptionsTable()
    ---@type FloatingWindowItem[]
    local optionsTable = {
        {
            title = "Open PWD Folder",
            action = function()
                vim.ui.open(".")
            end,
        },
        {
            title = "Change indentation style",
            action = function()
                require("utils").show_indentation_popup()
            end,
        },
        { title = "Open LazyDocker", action = "LazyDocker" },
        { title = "Search for TODOs", action = "TodoTelescope" },
        {
            title = "Toggle inactive shade",
            action = function()
                require("shade").toggle()
            end,
        },
        { title = "Edit color", action = "CccPick" },
        { title = "Toggle Debug Windows", action = "DapUiToggleWindows" },
    }

    -- Restart command, but only for >= nvim-0.12
    if vim.fn.has("nvim-0.12") then
        table.insert(optionsTable, { title = "Restart Neovim", action = "Restart" })
    end

    -- Switch between C/C++ Header and Implementation files
    if vim.tbl_contains(require("filetypes")["cpp"], vim.bo.filetype) then
        table.insert(optionsTable, {
            title = "Open Header/Implementation file",
            action = "ClangdSwitchSourceHeader",
        })
    end

    local currentFileFolderPath = vim.api.nvim_eval("expand('%:p:h')")
    if string.len(currentFileFolderPath) > 0 then
        table.insert(optionsTable, 1, {
            title = "Open File Folder",
            action = function()
                vim.ui.open(currentFileFolderPath)
            end,
        })
    end

    local currentFilePath = vim.api.nvim_buf_get_name(0)
    if string.len(currentFilePath) > 0 then
        table.insert(optionsTable, 1, {
            title = "Open File",
            action = function()
                vim.ui.open(currentFilePath)
            end,
        })

        -- Check if in Git directory
        local in_git_repo = utils.cwd_in_git_repo()
        if in_git_repo == "repo" or in_git_repo == "worktree" then
            -- TODO: Also check if the current buffer is actually a file
            table.insert(optionsTable, 2, { title = "Open File In Browser", action = "GBrowse" })
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
    if action then
        if action.build then
            local text = vim.is_callable(action.build) and "Build in terminal" or "Build"
            table.insert(optionsTable, 1, { title = text, action = action.build })
        end
        if action.run then
            local text = vim.is_callable(action.run) and "Run in terminal" or "Run"
            table.insert(optionsTable, 1, { title = text, action = action.run })
        end
        if action.preview then
            local text = vim.is_callable(action.preview) and "Preview in terminal" or "Preview"
            table.insert(optionsTable, 1, { title = text, action = action.preview })
        end
    end

    return optionsTable
end

-- Open options window
function Module.show()
    utils.showFloatingMenu(Module.getOptionsTable())
end

return Module
