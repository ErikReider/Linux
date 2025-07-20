-- vim.filetype.add({
--     pattern = { "*.glsl", "*.vert", "*.tesc", "*.tese", "*.geom", "*.frag", "*.comp", "*.vs", "*.fs" },
--     command = "set filetype=glsl",
-- })
vim.filetype.add({
    pattern = {
        -- PHP Blade
        [".*%.blade%.php"] = "blade",
    },
    extension = {
        -- Json files support comments
        json = "jsonc",

        -- GLSL
        glsl = "glsl",
        vert = "glsl",
        tesc = "glsl",
        tese = "glsl",
        geom = "glsl",
        frag = "glsl",
        comp = "glsl",
        vs = "glsl",
        fs = "glsl",

        -- React
        ts = "typescriptreact",
        tsx = "typescriptreact",
        js = "javascriptreact",
        jsx = "javascriptreact",
    },
})

vim.filetype.add({
    pattern = {
        -- GitHub Actions
        [".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
    },
})
