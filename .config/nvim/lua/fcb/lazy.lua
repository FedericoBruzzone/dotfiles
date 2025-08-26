local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { 'nvim-telescope/telescope.nvim' },
    { 'nvim-lua/plenary.nvim' },
    { "nvim-telescope/telescope-symbols.nvim" }, -- UNICODE CHARACTERS

    -- LSP
    { "neovim/nvim-lspconfig" },   -- enable LSP
    { "williamboman/mason.nvim" }, -- simple to use language server installer
    { "williamboman/mason-lspconfig.nvim" },
    -- DAP
    { "mfussenegger/nvim-dap" },
    { "nvim-neotest/nvim-nio" },
    { "rcarriga/nvim-dap-ui" },
    -- AUTO COMPLETION
    { "hrsh7th/nvim-cmp" },         -- The completion plugin
    { "hrsh7th/cmp-buffer" },       -- buffer completions
    { "hrsh7th/cmp-path" },         -- path completions
    { "saadparwaiz1/cmp_luasnip" }, -- snippet completions
    { "hrsh7th/cmp-nvim-lsp" },     -- LSP completions
    { "hrsh7th/cmp-nvim-lua" },     -- nvim lua completions
    -- FORMAT
    { "nvimtools/none-ls.nvim" },
    -- SNIPPETS
    -- { "L3MON4D3/LuaSnip" },             --snippet engine
    -- { "rafamadriz/friendly-snippets" }, -- a bunch of snippets to use

    -- SYNTAX HIGHLIGHTING
    { 'nvim-treesitter/nvim-treesitter',      build = ":TSUpdate" },
    -- { 'nvim-treesitter/nvim-treesitter-textobjects' },
    -- { 'nvim-treesitter/nvim-treesitter-context' },



    -- GIT
    { "lewis6991/gitsigns.nvim" },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "sindrets/diffview.nvim", -- optional - Diff integration
        },
        config = true
    },

    -- COMMENT
    { 'numToStr/Comment.nvim' },

    -- MULTICURSOR
    {
        "brenton-leighton/multiple-cursors.nvim",
        version = "*", -- Use the latest tagged version
        opts = {
            custom_key_maps = {
                { "n", "<Leader>|", function() require("multiple-cursors").align() end },
            },
        },
        keys = {
            { "<C-S-Up>",   "<Cmd>MultipleCursorsAddUp<CR>",            mode = { "n", "i", "x" }, desc = "Add cursor and move up" },
            { "<C-S-Down>", "<Cmd>MultipleCursorsAddDown<CR>",          mode = { "n", "i", "x" }, desc = "Add cursor and move down" },
            { "<C-d>",      "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = { "n", "x" },      desc = "Add cursor and jump to next cword" },
            { "<leader>l",  "<Cmd>MultipleCursorsAddMatches<CR>",       mode = { "n", "x" },      desc = "Add cursors to cword" },
        },
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
    },

    -- HANDLE SESSIONS
    { 'rmagatti/auto-session', },

    -- ERROR HANDLING
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
        },
    },

    -- MARKDOWN PREVIEW
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },

    -- COPILOT
    {
        "github/copilot.vim",
        config = function()
            -- vim.g.copilot_enabled = 0 -- Disable copilot
        end
    },


    --- UI
    { "AlexvZyl/nordic.nvim" },
    { "nvim-tree/nvim-web-devicons" }, -- File icons
    { "SmiteshP/nvim-navic" },         -- LSP status in the statusline
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        }
    },
    { 'akinsho/bufferline.nvim' },             -- Bufferline
    { 'nvim-lualine/lualine.nvim', },          -- Statusline
    { "nvim-tree/nvim-tree.lua", },            -- File Explorer
    { "lukas-reineke/indent-blankline.nvim" }, -- Indentation guides
    { 'sphamba/smear-cursor.nvim' },           -- Smooth cursor movement
})
