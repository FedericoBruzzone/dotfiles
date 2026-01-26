-- return {
--     "nvim-treesitter/nvim-treesitter",
--     build = ":TSUpdate",
-- }
-- :checkhealth nvim-treesitter
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.config").setup()
            require('nvim-treesitter').install({
                "json",
                "python",
                "ron",
                "javascript",
                "haskell",
                "query",
                "typescript",
                "tsx",
                "rust",
                "zig",
                "php",
                "yaml",
                "html",
                "css",
                "markdown",
                "markdown_inline",
                "bash",
                "lua",
                "vim",
                "vimdoc",
                "c",
                "dockerfile",
                "gitignore",
                "astro",
                "llvm"
            })

            -- Remap to enable/disable treesitter
            vim.keymap.set('n', '<leader>ts', function()
                if vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then
                    vim.treesitter.stop()
                    print("Treesitter disabled")
                else
                    vim.treesitter.start()
                    print("Treesitter enabled")
                end
            end, { desc = "Toggle Treesitter" })

            -- vim.api.nvim_create_autocmd('FileType', {
            --     -- pattern = { 'yml', 'llvm', 'gitcommit', 'c', 'cpp', 'json', 'python' },
            --     -- pattern  = '*',
            --     callback = function()
            --         -- syntax highlighting, provided by Neovim
            --         vim.treesitter.start()
            --         -- folds, provided by Neovim
            --         vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            --         vim.wo.foldmethod = 'expr'
            --         -- indentation, provided by nvim-treesitter
            --         vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            --     end,
            -- })
        end
    }
}
