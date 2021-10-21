local uncrustify = {}

uncrustify.init = function(language, custom_config)
    if not language then return nil end

    local config_file = ""
    if custom_config then
        config_file = custom_config
    else
        local cwdcfg = ".uncrustify.cfg"
        local homecfg = os.getenv("HOME") .. "/.uncrustify.cfg"
        if vim.fn.filereadable(cwdcfg) then
            config_file = cwdcfg
        elseif vim.fn.filereadable(homecfg) then
            config_file = homecfg
        end
    end
    return {
        formatCommand = "uncrustify -q -l " .. language .. " -c " .. config_file,
        formatStdin = true
    }
end

return uncrustify
