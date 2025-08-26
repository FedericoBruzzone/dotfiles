-- https://docs.rockylinux.org/books/nvchad/nvchad_ui/nvimtree/

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- <S-i> will toggle visibility of hidden files
-- <S-h> will toggle visibility of dotfiles
require("nvim-tree").setup({
    -- actions = {
    --     open_file = {
    --         quit_on_open = true,
    --     },
    -- },
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
        -- Remove devicons
        -- icons = {
        --     show = {
        --         folder_arrow = false,
        --         folder = false,
        --         file = false,
        --     },
        -- },
    },
    -- filters = {
    --         dotfiles = true,
    -- },
})

vim.keymap.set('n', '<C-b>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>r', ':NvimTreeRefresh<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>n', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })

-- Automatically close NvimTree when quitting.
vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
        local invalid_win = {}
        local wins = vim.api.nvim_list_wins()
        for _, w in ipairs(wins) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
            if bufname:match("NvimTree_") ~= nil then
                table.insert(invalid_win, w)
            end
        end
        if #invalid_win == #wins - 1 then
            -- Should quit, so we close all invalid windows.
            for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
        end
    end
})
