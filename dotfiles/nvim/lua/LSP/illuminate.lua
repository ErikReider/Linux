local g = {}
g.init = function(client)
    require('illuminate').on_attach(client)
    map('n', '<A-n>',
        '<cmd>lua require("illuminate").next_reference{wrap=true}<cr>',
        {noremap = true})
    map('n', '<A-S-n>',
        '<cmd>lua require("illuminate").next_reference{reverse=true,wrap=true}<cr>',
        {noremap = true})
end
return g
