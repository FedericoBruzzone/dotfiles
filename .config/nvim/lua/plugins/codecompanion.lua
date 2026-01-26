-- https://codecompanion.olimorris.dev/
return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {
        -- NOTE: The log_level is in `opts.opts`
        opts = {
            log_level = "DEBUG", -- or "TRACE"
        },
    },
    init = function()
        vim.keymap.set({ "n", "v" }, "<D-S-b>", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
        vim.keymap.set({ "n", "v" }, "<C-Enter>", "<cmd>CodeCompanion<cr>", { noremap = true, silent = true })

        -- Expand 'cc' into 'CodeCompanion' in the command line
        vim.cmd([[cab cc CodeCompanion]])
    end
}
