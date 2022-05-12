local M = {}
local loop = vim.loop
local handle, pid

local theme_func

local function change_theme(style_result)
    -- Color scheme
    local style = "dark"
    if type(style_result) == "string" then
        if string.find(style_result, "light")
            or string.find(style_result, "default") then
            style = "light"
        end
    end
    theme_func(style)
end

-- Monitor
local function gsettings_watcher()
    local stdout = loop.new_pipe(false)
    local stderr = loop.new_pipe(false)

    local function on_done()
        print("GSettings watcher stopped...")

        vim.loop.read_stop(stdout)
        vim.loop.read_stop(stderr)

        local function safe_close(_handle)
            if not vim.loop.is_closing(_handle) then
                vim.loop.close(_handle)
            end
        end

        safe_close(handle)
        safe_close(stdout)
        safe_close(stderr)

        local _handle = io.popen("kill " .. pid)
        if _handle ~= nil then
            _handle:close()
        end
    end

    local function onread(err, data)
        if err then
            print('ERROR: ', err)
        end
        vim.schedule(function()
            change_theme(data)
        end, 0)
    end

    handle, pid = loop.spawn(
        'gsettings',
        {
            args = { "monitor", "org.gnome.desktop.interface", "color-scheme" },
            stdio = { nil, stdout, stderr }
        },
        vim.schedule_wrap(on_done)
    )
    loop.read_start(stdout, onread)
    loop.read_start(stderr, onread)

    -- Kills the gsettings process before exit
    vim.api.nvim_create_autocmd("VimLeavePre", { callback = on_done })
end

function M.init(func)
    theme_func = func

    local installed_handle = io.popen("which gsettings")
    if installed_handle ~= nil then
        local installed_result = installed_handle:read("*a")
        installed_handle:close()
        if installed_result ~= "" then
            local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme")
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
