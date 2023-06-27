-- TODO: Use tmux to gain per split tablines
require("smart-splits").setup({
  -- Ignored filetypes (only while resizing)
  ignored_filetypes = {
    "nofile",
    "quickfix",
    "prompt",
  },
  -- Ignored buffer types (only while resizing)
  ignored_buftypes = { "NvimTree" },
  default_amount = 3,
  at_edge = "wrap",
  resize_mode = {
    -- key to exit persistent resize mode
    quit_key = "<C-c>",
    -- keys to use for moving in resize mode
    -- in order of left, down, up right
    resize_keys = { "<left>", "<down>", "<up>", "<right>" },
    -- set to true to silence the notifications
    -- when entering/exiting persistent resize mode
    silent = false,
    -- must be functions, they will be executed when
    -- entering or exiting the resize mode
    hooks = {
      on_enter = nil,
      on_leave = nil,
    },
  },
  -- ignore these autocmd events (via :h eventignore) while processing
  -- smart-splits.nvim computations, which involve visiting different
  -- buffers and windows. These events will be ignored during processing,
  -- and un-ignored on completed. This only applies to resize events,
  -- not cursor movement events.
  ignored_events = {
    "BufEnter",
    "WinEnter",
  },
  -- enable or disable the tmux integration
  tmux_integration = false,
  -- disable tmux navigation if current tmux pane is zoomed
  disable_multiplexer_nav_when_zoomed = true,
})
