local fterm = require("FTerm")

local window = fterm:new({
    cmd = "lazydocker",
    dimensions = {height = 0.9, width = 0.9}
})

vim.api.nvim_create_user_command("LazyDocker", function() window:toggle() end,
                                 {})

