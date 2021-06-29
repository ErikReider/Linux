function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

function _G.iterDir(dir, callback)
    local table = vim.api.nvim_eval("split(glob('" .. dir .. "'), '\n')")
    for _, f in ipairs(table) do callback(f) end
end
