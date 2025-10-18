local CSPELL_CONFIG_FILES = {
    "cspell.json",
    ".cspell.json",
    "cSpell.json",
    ".cspell.json",
    ".cspell.config.json",
}

---@param filename string
---@param cwd string
---@return string|nil
local function find_file(filename, cwd)
    ---@type string|nil
    local current_dir = cwd
    local root_dir = "/"

    repeat
        local file_path = current_dir .. "/" .. filename
        local stat = vim.loop.fs_stat(file_path)
        if stat and stat.type == "file" then
            return file_path
        end

        current_dir = vim.loop.fs_realpath(current_dir .. "/..")
    until current_dir == root_dir

    return nil
end

--- Find the first cspell.json file in the directory tree
---@param cwd string
---@return string|nil
local find_cspell_config_path = function(cwd)
    for _, file in ipairs(CSPELL_CONFIG_FILES) do
        local path = find_file(file, cwd or vim.loop.cwd())
        if path then
            return path
        end
    end
    return nil
end

--- Find the project .vscode directory, if any
---@param cwd string
---@return string|nil
local function find_vscode_config_dir(cwd)
    ---@type string|nil
    local current_dir = cwd
    local root_dir = "/"

    repeat
        local dir_path = current_dir .. "/.vscode"
        local stat = vim.loop.fs_stat(dir_path)
        if stat and stat.type == "directory" then
            return dir_path
        end

        current_dir = vim.loop.fs_realpath(current_dir .. "/..")
    until current_dir == root_dir

    return nil
end
return {
    -- { "davidmh/cspell.nvim" },

    -- null-ls.nvim reloaded / Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.

    -- {
    --     "nvimtools/none-ls.nvim",
    --     dependencies = { "Joakker/lua-json5", build = "./install.sh", lazy = false },
    --     opts = function(_, opts)
    --         opts.fallback_severity = vim.diagnostic.severity.INFO
    --         -- cspell
    --         local config = {
    --             find_json = function(cwd)
    --                 local vscode_dir = find_vscode_config_dir(cwd)
    --                 if vscode_dir ~= nil then return find_cspell_config_path(vscode_dir) end
    --                 -- not in a project with vscode, so try to find the first cspell config in the tree
    --                 return find_cspell_config_path(cwd)
    --             end,
    --             decode_json = require("json5").parse
    --         }
    --         local cspell = require("cspell")
    --         -- local sources = { cspell.diagnostics, cspell.code_actions }
    --
    --         return {
    --             sources = {
    --                 cspell.diagnostics.with({ config = config }),
    --                 cspell.code_actions.with({ config = config })
    --             }
    --         }
    --     end
    -- }
}
