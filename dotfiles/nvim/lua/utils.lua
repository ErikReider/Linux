_G.map = vim.keymap.set

---Get the MASON LSP executable path
---@param name string The name of the LSP (ex: "elixir-ls").
---@param default string the default path to use if LSP wasn't found.
---@return string string The LSPs path.
function _G.get_lsp_path(name, default)
    local path = path_join(vim.fn.stdpath("data"), "mason", "bin", name)
    if file_exists(path) then
        return path
    end
    return default
end

---Split string into a table of strings using a separator.
---@param inputString string The string to split.
---@param sep string The separator to use.
---@return table table A table of strings.
function _G.split(inputString, sep)
  local fields = {}

  local pattern = string.format("([^%s]+)", sep)
  local _ = string.gsub(inputString, pattern, function(c)
    fields[#fields + 1] = c
  end)

  return fields
end

---Joins arbitrary number of paths together.
---@param ... string The paths to join.
---@return string
function _G.path_join(...)
    local args = {...}
    if #args == 0 then return "" end

    local path_separator = "/"
    local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1
    if is_windows == true then
      path_separator = "\\"
    end

    local all_parts = {}
    if type(args[1]) == "string" and args[1]:sub(1, 1) == path_separator then
        all_parts[1] = ""
    end

    for _, arg in ipairs(args) do
        local arg_parts = split(arg, path_separator)
        vim.list_extend(all_parts, arg_parts)
    end
    return table.concat(all_parts, path_separator)
end

function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

function _G.iterDir(dir, callback)
    local table = vim.api.nvim_eval("split(glob('" .. dir .. "'), '\n')")
    for _, f in ipairs(table) do callback(f) end
end

function _G.tableContains(table, val)
    for i = 1, #table do if table[i] == val then return true end end
    return false
end

function _G.disownCMD(cmd) return "!" .. cmd .. " 2>/dev/null >&2 &; disown" end

function _G.runCmdInTerm(cmd, tryStayOpen)
    local open = tryStayOpen == true and "; exec $SHELL" or ""
    return disownCMD("$TERM -e $SHELL -c \'" .. cmd .. open .. "\'")
end

function _G.splitString(str, delimiter)
    local matches = {}
    for substring in string.gmatch((str .. delimiter), "(.-)" .. delimiter) do
        table.insert(matches, substring)
    end
    return matches
end

function _G.tableMerge(t1, t2)
    for k, v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                tableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

function _G.file_exists(path)
    local f = io.open(path, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

function _G.showFloatingMenu(items)
    if type(items) ~= "table" then
        print("ITEMS NOT A TABLE!")
        return
    end
    local keysArray = {}
    local itemsArray = {}
    local maxStringLength = 0
    local length = 0
    for _, item in pairs(items) do
        table.insert(keysArray, item.title)
        itemsArray[item.title] = item.action
        local len = string.len(item.title)
        if len > maxStringLength then maxStringLength = len end
        length = length + 1
    end
    if maxStringLength < 30 then maxStringLength = 20 end

    vim.ui.select(keysArray, {
        prompt = "Options",
        kind = "floatingwindow",
        maxStringLength = maxStringLength,
        entries = length
    }, function(selected)
        if selected == nil then return end
        local option = itemsArray[selected]
        vim.cmd("silent " .. option)
    end)
end
