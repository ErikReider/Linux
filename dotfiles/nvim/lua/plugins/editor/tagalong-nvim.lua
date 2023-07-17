-- Changing tag name also changed matching tag
return {
    {
        -- NOTE: Needed for Elixir heex files
        "AndrewRadev/tagalong.vim",
        enabled = true,
        config = function()
            vim.g.tagalong_additional_filetypes = { "heex" }
            -- inoremap <silent> <c-c> <c-c>:call tagalong#Apply()<cr>
            map("i", "<c-c>", "<c-c>:call tagalong#Apply()<cr>", { noremap = true, silent = true })
        end
    }
}
