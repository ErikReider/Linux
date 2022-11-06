_G.map = vim.api.nvim_set_keymap

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

function _G.file_exists(name)
    local f = io.open(name, "r")
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
