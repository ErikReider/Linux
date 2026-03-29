local constants = {}

constants.dir_plugin_bin = vim.fs.joinpath(vim.fn.stdpath("config"), "bin")
constants.dir_lazy = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")

return constants
