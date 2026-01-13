return {
    "vague-theme/vague.nvim",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other plugins
    config = function()
        -- NOTE: you do not need to call setup if you don't want to.
        require("vague").setup({
            -- optional configuration here
        })
        vim.cmd("colorscheme vague")
        -- vim.api.nvim_set_hl(0, "Normal", { bg = "Black" })
        -- vim.api.nvim_set_hl(0, "SignColumn", { bg = "Black" })
    end
}
