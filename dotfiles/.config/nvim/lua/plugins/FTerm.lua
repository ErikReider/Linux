-- Floating terminals
local opts = { noremap = true, silent = true }

return {
    {
        "numtostr/FTerm.nvim",
        config = function()
            local fterm = require("FTerm")
            fterm.setup({
                border = "rounded",
                auto_close = true,
                hl = "Normal",
                blend = 20,
                dimensions = { height = 0.9, width = 0.9 }
            })

            -- Example keybindings
            map("n", "<F7>", [[<CMD>lua require("FTerm").toggle()<CR>]], opts)
            map("t", "<F7>", [[<C-\><C-n><CMD>lua require("FTerm").toggle()<CR>]], opts)
            map("t", "<F9>", [[<C-\><C-n><CMD>lua require("FTerm").exit()<CR>]], opts)

            --
            -- LazyGit
            --
            local function new_window()
                local style = vim.g.gtk_style
                local configs = {}

                -- Use default config if it exists
                local default_conf = os.getenv("HOME") .. "/.config/lazygit/config.yml"
                if file_exists(default_conf) then table.insert(configs, default_conf) end

                -- Supply Light theme if using light mode
                if style == "light" then
                    local light_conf = os.getenv("HOME") .. "/.config/nvim/lazygit-light-config.yml"
                    if file_exists(light_conf) then table.insert(configs, light_conf) end
                end

                return fterm:new({
                    cmd = "lazygit --use-config-file=" .. table.concat(configs, ","),
                    dimensions = { height = 0.9, width = 0.9 }
                })
            end

            local lazyGit_window = nil
            vim.api.nvim_create_user_command("LazyGit", function()
                if lazyGit_window == nil then
                    lazyGit_window = new_window()
                    lazyGit_window:open()
                else
                    lazyGit_window:toggle()
                end
            end, {})
            -- Be able to close when theme changes (lazygit theme doesn't hotreload...)
            vim.api.nvim_create_user_command("LazyGitClose", function()
                if lazyGit_window ~= nil then lazyGit_window:close() end
                lazyGit_window = nil
            end, {})

            map("n", "<F8>", "<CMD>LazyGit<CR>", opts)
            map("t", "<F8>", "<C-\\><C-n><CMD>LazyGit<CR>", opts)
            map("t", "<F10>", "<C-\\><C-n><CMD>LazyGitClose<CR>", opts)

            --
            -- LazyDocker
            --
            local lazyDocker_window = nil
            vim.api.nvim_create_user_command("LazyDocker", function()
                if lazyDocker_window == nil then
                    lazyDocker_window = fterm:new({
                        cmd = "lazydocker",
                        dimensions = { height = 0.9, width = 0.9 }
                    })
                    lazyDocker_window:open()
                else
                    lazyDocker_window:toggle()
                end
            end, {})
        end
    }
}
