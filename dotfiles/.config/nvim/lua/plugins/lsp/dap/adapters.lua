local utils = require("utils")
local dap = require("dap")

-- Configs
-- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/adapters.lua

-- cppdbg (C,C++,Rust)
dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = "OpenDebugAD7",
    options = { detached = not utils.is_windows }
}

return {}
