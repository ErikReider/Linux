if vim.g.neovide then
    vim.g.neovide_profiler = false
    vim.g.neovide_confirm_quit = true

    -- Scroll Animation Length
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_cursor_vfx_mode = ""

    vim.g.neovide_refresh_rate_idle = 5

    vim.g.transparency = 0.8
    vim.g.neovide_opacity = 0.8

    -- Floating blur
    vim.g.neovide_floating_blur_amount_x = 12.0
    vim.g.neovide_floating_blur_amount_y = 12.0

    vim.g.neovide_floating_corner_radius = 20.0
    vim.opt.linespace = 2

    -- Floating Shadow
    vim.g.neovide_floating_shadow = true
    vim.g.neovide_floating_z_height = 10
    vim.g.neovide_light_angle_degrees = 90
    vim.g.neovide_light_radius = 10

    vim.o.guifont = "FiraCode Nerd Font Mono"

    ---System clipboard
    -- Copy
    map("n", "<c-s-c>", "\"+y", { silent = true, noremap = true })
    map("v", "<c-s-c>", "\"+y", { silent = true, noremap = true })
    -- Paste
    map("n", "<c-s-v>", "\"+p", { silent = true, noremap = true })
    map("i", "<c-s-v>", "<c-r>+", { silent = true, noremap = true })
    map("c", "<c-s-v>", "<c-r>+", { silent = true, noremap = true })
    -- Use <c-r> to insert original character without triggering things like auto-pairs
    map("i", "<c-r>", "<c-s-v>", { silent = true, noremap = true })
end
