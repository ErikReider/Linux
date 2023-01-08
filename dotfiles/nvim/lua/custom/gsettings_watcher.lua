local M = {}
local theme_func

local function change_theme(style_result)
    -- Color scheme
    local style = "dark"
    if type(style_result) == "string" then
        if string.find(style_result, "light") or
            string.find(style_result, "default") then style = "light" end
    end
    theme_func(style)
end

-- Monitor
local function gsettings_watcher()
    local function on_stdout(_, data, _) change_theme(data[1]) end

    vim.fn.jobstart(
        "gsettings monitor org.gnome.desktop.interface color-scheme",
        {on_stdout = on_stdout})
end

function M.init(func)
    theme_func = func

    -- Get the current color scheme if gsettings exists in $PATH
    local installed_handle = io.popen("which gsettings")
    if installed_handle ~= nil then
        local installed_result = installed_handle:read("*a")
        installed_handle:close()
        if installed_result ~= "" then
            local handle = io.popen(
                               "gsettings get org.gnome.desktop.interface color-scheme")
            if handle ~= nil then
                local result = handle:read("*a")
                handle:close()
                change_theme(result)
                gsettings_watcher()
                return
            end
        end
    end
    change_theme()
end

return M
