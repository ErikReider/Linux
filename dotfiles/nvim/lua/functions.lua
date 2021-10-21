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

function _G.disownCMD(cmd) return "!2>/dev/null 1>&2 " .. cmd .. " &; disown" end

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
