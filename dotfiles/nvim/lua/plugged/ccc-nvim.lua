local ccc = require("ccc")
local mapping = ccc.mapping
local input = ccc.input
local output = ccc.output
local picker = ccc.picker

ccc.setup({
    inputs = {input.rgb, input.hsl},
    outputs = {output.hex, output.hex_short, output.css_rgb, output.css_hsl},
    highlighter = {
        auto_enable = true,
        max_byte = 100 * 1024, -- 100 KB
        filetypes = {},
        excludes = {},
        lsp = true
    },
    convert = {
        {picker.hex, output.css_rgb}, {picker.css_rgb, output.css_hsl},
        {picker.css_hsl, output.hex}
    },
    recognize = {
        input = true,
        output = true,
        pattern = {
            [picker.css_rgb] = {input.rgb, output.rgb},
            [picker.css_name] = {input.rgb, output.rgb},
            [picker.hex] = {input.rgb, output.hex},
            [picker.css_hsl] = {input.hsl, output.css_hsl},
            [picker.css_hwb] = {input.hwb, output.css_hwb},
            [picker.css_lab] = {input.lab, output.css_lab},
            [picker.css_lch] = {input.lch, output.css_lch},
            [picker.css_oklab] = {input.oklab, output.css_oklab},
            [picker.css_oklch] = {input.oklch, output.css_oklch}
        }
    },
    disable_default_mappings = true,
    mappings = {
        ["q"] = mapping.quit,
        ["<ESC>"] = mapping.quit,
        ["<CR>"] = mapping.complete,
        ["i"] = mapping.toggle_input_mode,
        ["o"] = mapping.toggle_output_mode,
        ["a"] = mapping.toggle_alpha,
        ["g"] = mapping.toggle_prev_colors,
        ["w"] = mapping.goto_next,
        ["b"] = mapping.goto_prev,
        ["<Up>"] = "-",
        ["<Down>"] = "+",
        ["<Right>"] = mapping.increase1,
        ["<S-Right>"] = mapping.increase5,
        ["<C-Right>"] = mapping.increase10,
        ["<Left>"] = mapping.decrease1,
        ["<S-Left>"] = mapping.decrease5,
        ["<C-Left>"] = mapping.decrease10,
        ["0"] = mapping.set0,
        ["1"] = function() ccc.set_percent(10) end,
        ["2"] = function() ccc.set_percent(20) end,
        ["3"] = function() ccc.set_percent(30) end,
        ["4"] = function() ccc.set_percent(40) end,
        ["5"] = mapping.set50,
        ["6"] = function() ccc.set_percent(60) end,
        ["7"] = function() ccc.set_percent(70) end,
        ["8"] = function() ccc.set_percent(80) end,
        ["9"] = function() ccc.set_percent(90) end
    }
})
