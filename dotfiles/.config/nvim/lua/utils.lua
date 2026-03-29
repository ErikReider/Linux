---@module "lazy"

local Job = require("plenary.job")

local utils = {}

--
-- LSP
--

---Get the MASON LSP executable path
---@param name string The name of the LSP (ex: "elixir-ls").
---@param default string the default path to use if LSP wasn't found.
---@return string string The LSPs path.
function utils.get_lsp_path(name, default)
    local path = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", name)
    if utils.file_exists(path) then
        return path
    end
    return default
end

---Get the LSP capabilities
function utils.get_lsp_capabilities()
    -- Add additional capabilities supported by nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

    capabilities.textDocument.completion.completionItem.snippetSupport = true
    -- For nvim-ufo
    capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
    return capabilities
end

--
-- Helpers
--

---@param msg string
function utils.notify_error(msg)
    vim.notify(msg, vim.log.levels.ERROR, nil)
end

---@alias CwdGitResult ("repo"|"worktree"|"bare")
---We cache the results of "git rev-parse"
---@type { [string]: CwdGitResult? }
local cwd_in_git_repo_cache = {}
---@return CwdGitResult?
function utils.cwd_in_git_repo()
    local cwd = vim.uv.cwd()
    if cwd == nil then
        utils.notify_error("utils.cwd_in_git_repo: cwd is nil")
        return nil
    end

    local cached_value = cwd_in_git_repo_cache[cwd]
    if cached_value ~= nil then
        return cached_value
    end

    ---@type CwdGitResult?
    local result = nil
    if utils.get_os_command_success({ "git", "rev-parse", "--show-toplevel" }, cwd) then
        result = "repo"
    elseif utils.get_os_command_success({ "git", "rev-parse", "--is-inside-work-tree" }, cwd) then
        result = "worktree"
    elseif utils.get_os_command_success({ "git", "rev-parse", "--is-bare-repository" }, cwd) then
        result = "bare"
    end

    cwd_in_git_repo_cache[cwd] = result
    return result
end

---We cache the results of "git rev-parse"
---@type { [string]: boolean? }
local cwd_is_git_repo_root_cache = {}
---@return boolean
function utils.cwd_is_git_repo_root()
    local cwd = vim.uv.cwd()
    if cwd == nil then
        utils.notify_error("utils.cwd_is_git_repo_root: cwd is nil")
        return false
    end

    local cached_value = cwd_is_git_repo_root_cache[cwd]
    if cached_value ~= nil then
        return cached_value
    end

    local result = vim.uv.fs_stat(vim.fs.joinpath(cwd, ".git")) ~= nil
    cwd_is_git_repo_root_cache[cwd] = result
    return result
end

--
-- String
--

---Converts the first character in a string to upper-case
---@param str string
---@return string
function utils.str_first_to_upper(str)
    return (str:gsub("^%l", string.upper))
end

---@param ... any
---@return string
function utils.serialize(...)
    local objects = vim.tbl_map(vim.inspect, { ... })
    return vim.inspect(objects)
end

--
-- Table
--

---@param table table|nil
---@return boolean
function utils.tbl_is_empty(table)
    return not table or next(table) == nil
end

--
-- OS Helpers
--

utils.is_windows = vim.fn.has("win32") == 1
utils.env_path_separator = (not utils.is_windows) and ":" or ";"

---Check if file exists
---@param ... string Path to file
function utils.file_exists(...)
    return vim.uv.fs_stat(vim.fs.joinpath(...)) ~= nil
end

---Prepends the provided path to NeoVims `variable` environment variable
---@param variable string
---@param ... string Additional path
function utils.prepend_path_to_ENV(variable, ...)
    local path = vim.fs.joinpath(...)
    if not vim.env[variable] then
        vim.env[variable] = path
    else
        vim.env[variable] = path .. utils.env_path_separator .. vim.env[variable]
    end
end

---Prepends the provided path to NeoVims PATH environment variable
---@param ... string The path
function utils.prepend_path_to_PATH(...)
    utils.prepend_path_to_ENV("PATH", ...)
end

---Prepends the provided plugins path to NeoVims PATH environment variable
---@param plugin LazyPlugin
---@param ... string Additional path
function utils.prepend_plugin_to_PATH(plugin, ...)
    utils.prepend_path_to_PATH(plugin.dir, ...)
end

---Prepends the provided plugins path to NeoVims PATH environment variable
---@param plugin LazyPlugin
---@param ... string Additional path
function utils.prepend_plugin_to_PYTHONPATH(plugin, ...)
    utils.prepend_path_to_ENV("PYTHONPATH", plugin.dir, ...)
end

---@param cmd string[] Command to run
---@param cwd string? Current working directory
---@return boolean?
function utils.get_os_command_success(cmd, cwd)
    if type(cmd) ~= "table" then
        utils.notify_error("get_os_command_success: cmd must be a table")
        return nil
    end
    local command = table.remove(cmd, 1)
    local _, ret = Job:new({
        command = command,
        args = cmd,
        cwd = cwd,
    }):sync()
    return ret == 0
end

---@param cmd table
---@param stay_open boolean?
function utils.run_cmd_in_term(cmd, stay_open)
    return require("snacks").terminal.open(cmd, {
        auto_close = not stay_open,
        win = {
            position = "bottom",
        },
    })
end

--
-- Other
--

---@return string
function utils.get_indentation_string()
    if not vim.o.expandtab then
        return "Tab Size: " .. vim.o.tabstop
    else
        return "Spaces: " .. vim.o.shiftwidth
    end
end

function utils.show_indentation_popup()
    vim.ui.select({ "tabs", "spaces", "change", "detect" }, {
        format_item = function(item)
            if item == "change" then
                return "Change indent size"
            elseif item == "detect" then
                return "Detect indent size"
            end
            return "Indent using " .. utils.str_first_to_upper(item)
        end,
    }, function(type_choice)
        if type(type_choice) ~= "string" then
            return
        end
        if type_choice == "detect" then
            vim.cmd("Sleuth")
            return
        end

        -- Display change size select UI
        vim.ui.select({ 2, 4, 8 }, {
            prompt = "Select indentation size for current file",
        }, function(size_choice)
            if type(size_choice) ~= "number" then
                return
            end
            vim.o.expandtab = type_choice == "spaces"
            vim.o.shiftwidth = size_choice
            vim.o.tabstop = size_choice
        end)
    end)
end

---@alias FloatingWindowItemAction string|function

---@class FloatingWindowItem
---@field title string
---@field action FloatingWindowItemAction

---@param items FloatingWindowItem[]
function utils.showFloatingMenu(items)
    if not vim.islist(items) then
        utils.notify_error("showFloatingMenu: items must be a table")
        return
    end

    ---@type string[]
    local titleArray = {}
    ---@type FloatingWindowItemAction[]
    local itemsArray = {}

    local maxStringLength = 0
    local numEntries = 0
    for _, item in pairs(items) do
        table.insert(titleArray, item.title)
        itemsArray[item.title] = item.action
        local len = string.len(item.title)
        if len > maxStringLength then
            maxStringLength = len
        end
        numEntries = numEntries + 1
    end
    if maxStringLength < 30 then
        maxStringLength = 20
    end

    vim.ui.select(titleArray, {
        prompt = "Options",
        kind = "floatingwindow",
        maxStringLength = maxStringLength,
        entries = numEntries,
    }, function(selected)
        if selected == nil then
            return
        end
        local option = itemsArray[selected]
        if type(option) == "function" and vim.is_callable(option) then
            option()
        else
            vim.cmd("silent " .. option)
        end
    end)
end

return utils
