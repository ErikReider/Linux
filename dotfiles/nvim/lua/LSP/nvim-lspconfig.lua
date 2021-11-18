local cmp = require('cmp')
local luasnip = require('luasnip');
local nvim_autopairs = require('nvim-autopairs')
-- local lsp_signature = require("lsp_signature")

require('lspsaga').init_lsp_saga({
    -- add your config value here
    -- default value
    -- use_saga_diagnostic_sign = true
    -- error_sign = '',
    -- warn_sign = '',
    -- hint_sign = '',
    -- infor_sign = '',
    -- dianostic_header_icon = '   ',
    -- code_action_icon = ' ',
    -- code_action_prompt = {
    -- enable = true,
    -- sign = true,
    -- sign_priority = 20,
    -- virtual_text = true
    -- },
    -- finder_definition_icon = '  ',
    -- finder_reference_icon = '  ',
    max_preview_lines = 10, -- preview lines of lsp_finder and definition preview
    finder_action_keys = {
        open = {'o', "<CR>"},
        vsplit = '<C-s>',
        split = '<C-i>',
        quit = {'<c-c>', "<ESC>", "q"},
        scroll_down = '<C-f>',
        scroll_up = '<C-b>'
    },
    code_action_keys = {quit = {'<c-c>', "<ESC>", "q"}, exec = '<CR>'},
    rename_action_keys = {quit = {'<c-c>', "<ESC>"}, exec = '<CR>'},
    -- definition_preview_icon = '  '
    border_style = "round",
    rename_prompt_prefix = ''
})

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noinsert'

-- Gutter diagnostic signs
local signs = {Error = "❌", Warn = "", Hint = "💡", Info = ""}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ""})
end

-- Go to definition
function _G.goto_definition(new_tab)
    -- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
    vim.lsp.handlers["textDocument/definition"] =
        function(_, result, ctx)
            local util = vim.lsp.util
            local log = require("vim.lsp.log")
            local api = vim.api
            if result == nil or vim.tbl_isempty(result) then
                local _ = log.info() and
                              log.info(ctx.method or "Nil", 'No location found')
                return nil
            end

            local res = vim.tbl_islist(result) and result[1] or result

            if (res.uri or res.targetUri) == nil then
                print("URI is nil...")
                return nil
            end
            local uri = vim.uri_to_fname(res.uri or res.targetUri)
            if new_tab and uri ~= vim.fn.expand("%:p") then
                vim.cmd("tab drop " .. uri)
            end

            util.jump_to_location(res)
            if #result > 1 then
                util.set_qflist(util.locations_to_items(result))
                api.nvim_command("copen")
                api.nvim_command("wincmd p")
            end
        end
    vim.lsp.buf.definition()
end

-- nvim-autopairs
nvim_autopairs.setup({disable_filetype = {"TelescopePrompt", "vim"}})

-- lsp_signature: Shows method parameters
-- Diabled until "https://github.com/ray-x/lsp_signature.nvim/issues/94" is fixed
-- lsp_signature.setup({
-- bind = false, -- This is mandatory, otherwise border config won't get registered.
-- -- If you want to hook lspsaga or other signature handler, pls set to false
-- doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
-- -- set to 0 if you DO NOT want any API comments be shown
-- -- This setting only take effect in insert mode, it does not affect signature help in normal
-- -- mode, 10 by default

-- floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

-- floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
-- -- will set to true when fully tested, set to false will use whichever side has more space
-- -- this setting will be helpful if you do not want the PUM and floating win overlap
-- fix_pos = function(signatures, _) -- second argument is the client
-- return signatures[1].activeParameter >= 0 and signatures[1].parameters >
-- 1
-- end, -- set to true, the floating window will not auto-close until finish all parameters
-- hint_enable = false, -- virtual hint enable
-- hint_prefix = "🗿 ", -- Panda for parameter
-- hint_scheme = "String",
-- use_lspsaga = true, -- set to true if you want to use lspsaga popup
-- hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
-- max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
-- -- to view the hiding contents
-- max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
-- handler_opts = {
-- border = "rounded" -- double, single, shadow, none
-- },

-- always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

-- auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
-- extra_trigger_chars = {",", "("}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
-- zindex = 50, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

-- padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc

-- transpancy = nil, -- disabled by default, allow floating win transparent value 1~100
-- shadow_blend = 36, -- if you using shadow as border use this set the opacity
-- shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
-- timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
-- toggle_key = '<M-x>' -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
-- })

-- nvim-cmp
local lsp_symbols = {
    Text = "  ",
    Method = "  ",
    Function = "  ",
    Constructor = "  ",
    Field = "  ",
    Variable = "[]",
    Class = " פּ ",
    Interface = " 蘒",
    Module = "  ",
    Property = "  ",
    Unit = " 塞 ",
    Value = "  ",
    Enum = " 練",
    Keyword = "  ",
    Snippet = "  ",
    Color = "  ",
    File = "  ",
    Reference = "  ",
    Folder = "  ",
    EnumMember = "  ",
    Constant = "  ",
    Struct = "  ",
    Event = "  ",
    Operator = "  ",
    TypeParameter = "<>"
}
cmp.setup({
    snippet = {expand = function(args) luasnip.lsp_expand(args.body) end},
    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = lsp_symbols[vim_item.kind]
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snip]",
                nvim_lua = "[Lua]",
                latex_symbols = "[Latx]",
                buffer = "[Buff]"
            })[entry.source.name]
            return vim_item
        end
    },
    preselect = cmp.PreselectMode.None,
    completion = {completeopt = vim.o.completeopt},
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping(function(fallback)
            if not cmp.visible() then
                cmp.complete()
            elseif cmp.visible() then
                cmp.close()
            else
                fallback()
            end
        end, {"i"}),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {"i", "s"}),
        ['<C-c>'] = cmp.mapping(function(fallback)
            -- If inside a snippet
            if (luasnip.jumpable(0)) then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>",
                                                                     true,
                                                                     false, true),
                                      "t", true)
            end
            cmp.close()
            fallback()
        end, {"i", "s"}),
        ["<ESC>"] = cmp.mapping(function(fallback)
            luasnip.unlink_current()
            fallback()
        end, {"i", "s"})
    },
    sources = {
        {name = 'nvim_lsp'}, {name = 'luasnip'}, {name = 'path'},
        {name = 'buffer'}
    }
})

-- Customizing how diagnostics are displayed
vim.lsp.handlers['textDocument/publishDiagnostics'] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = {
            source = "always", -- Or "if_many"
            prefix = '■'
        },
        signs = true,
        underline = true,
        update_in_insert = false
    })

-- Adds auto insertion of "()" in cmp
-- require("nvim-autopairs.completion.cmp").setup({
    -- map_cr = true, --  map <CR> on insert mode
    -- map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
    -- auto_select = true, -- automatically select the first item
    -- insert = false, -- use insert confirm behavior instead of replace
    -- map_char = { -- modifies the function or method delimiter by filetypes
        -- all = '(',
        -- tex = '{'
    -- }
-- })

require("LSP.lua_snip")

require("LSP.lsp-servers")
