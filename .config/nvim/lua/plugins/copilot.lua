return {
    "github/copilot.vim",
    config = function()
        vim.g.copilot_enabled = 0 -- Disable copilot

        vim.api.nvim_set_keymap('n', '<leader>ce', ':Copilot enable<CR>', { noremap = true })
        vim.api.nvim_set_keymap('n', '<leader>cd', ':Copilot disable<CR>', { noremap = true })
        vim.api.nvim_set_keymap('i', '<C-l>', '<Plug>(copilot-accept-word)', { noremap = true, silent = true })
    end
}
