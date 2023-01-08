local cmp = require('cmp')
local luasnip = require('luasnip');
local nvim_autopairs = require('nvim-autopairs')
local lsp_signature = require("lsp_signature")

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noinsert'

-- Gutter diagnostic signs
local signs = {
    DiagnosticSignError = "❌",
    DiagnosticSignWarn = "",
    DiagnosticSignHint = "💡",
    DiagnosticSignInfo = ""
}
for type, icon in pairs(signs) do
    vim.fn.sign_define(type, {text = icon, texthl = type, numhl = ""})
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
lsp_signature.setup({
    bind = true,
    doc_lines = 0,
    handler_opts = {border = "rounded"},
    always_trigger = false,

    floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

    floating_window_above_cur_line = true,

    floating_window_off_x = 0,
    floating_window_off_y = 0,

    fix_pos = false,
    hint_enable = true,
    hint_prefix = "",
    hint_scheme = "Comment",
    hi_parameter = "LspSignatureActiveParameter",
    max_height = 10,
    max_width = 80,

    zindex = 200,

    shadow_blend = 36,
    shadow_guibg = 'Black',
    timer_interval = 200,
    toggle_key = nil
})

-- nvim-cmp
local lsp_symbols = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = ""
}
cmp.setup({
    snippet = {expand = function(args) luasnip.lsp_expand(args.body) end},
    sorting = {
        comparators = {
            cmp.config.compare.offset, cmp.config.compare.exact,
            cmp.config.compare.score, require("cmp-under-comparator").under,
            cmp.config.compare.kind, cmp.config.compare.sort_text,
            cmp.config.compare.length, cmp.config.compare.order
        }
    },
    formatting = {
        fields = {"kind", "abbr"},
        format = function(_, vim_item)
            -- Truncate text
            local label = vim_item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, 40)
            if truncated_label ~= label then
                vim_item.abbr = truncated_label .. "…"
            end

            vim_item.kind = lsp_symbols[vim_item.kind] or ""
            vim_item.menu = nil
            return vim_item
        end
    },
    preselect = cmp.PreselectMode.None,
    completion = {completeopt = vim.o.completeopt},
    mapping = cmp.mapping.preset.insert({
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
    }),
    sources = {
        {name = 'nvim_lsp'}, {name = 'luasnip'}, {name = 'path'},
        {name = 'buffer'}
    }
})

-- Customizing how diagnostics are displayed
vim.lsp.handlers['textDocument/publishDiagnostics'] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Replace virtual_text with lsp_lines.nvim
        virtual_text = false,
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

require("LSP.mason")

require("LSP.lsp-servers")
