if vim.g.neovide == true then
  vim.g.neovide_profiler = false
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_scroll_animation_length = 0.3
  vim.g.neovide_cursor_vfx_mode=""
  vim.g.neovide_refresh_rate=60
  vim.g.neovide_transparency=0.8
  vim.g.neovide_floating_blur_amount_x = 0.0
  vim.g.neovide_floating_blur_amount_y = 0.0
  vim.cmd('set guifont="FiraCode Nerd font"')

  ---System clipboard
  -- Copy
  map("n", "<c-s-c>", "+y", {silent = true, noremap = true})
  map("v", "<c-s-c>", "+y", {silent = true, noremap = true})
  -- Paste
  map("n", "<c-s-v>", "+p", {silent = true, noremap = true})
  map("i", "<c-s-v>", "<c-r>+", {silent = true, noremap = true})
  map("c", "<c-s-v>", "<c-r>+", {silent = true, noremap = true})
  -- Use <c-r> to insert original character without triggering things like auto-pairs
  map("i", "<c-r>", "<c-s-v>", {silent = true, noremap = true})
end
