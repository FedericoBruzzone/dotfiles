-- -- Autopairs
-- { 'nvim-tree/nvim-web-devicons' },
-- { "phha/zenburn.nvim" },
-- { 'rktjmp/lush.nvim' },
-- {
--     'AlexvZyl/nordic.nvim',
--     lazy = false,
--     priority = 1000,
--     config = function()
--         require 'nordic'.load()
--     end
-- }
-- { 'rose-pine/neovim' },
-- { "catppuccin/nvim",               as = "catppuccin" },
-- { 'Shatur/neovim-ayu',             as = 'ayu' },
-- { 'folke/tokyonight.nvim',         as = 'tokyonight', },
-- { 'maxmx03/solarized.nvim',        as = 'solarized' },
-- { 'mcchrish/zenbones.nvim',        as = 'zenbones', },
-- { 'bluz71/vim-moonfly-colors',     as = 'moonfly' },
-- { 'blazkowolf/gruber-darker.nvim', as = 'gruber-darker' },
-- {
--     'uloco/bluloco.nvim',
--     lazy = false,
--     priority = 1000,
-- },
-- {
--     "scottmckendry/cyberdream.nvim",
--     lazy = false,
--     priority = 1000,
-- },
-- {
--     'Verf/deepwhite.nvim',
--     lazy = false,
--     priority = 1000,
-- }
-- { "EdenEast/nightfox.nvim", as = 'nightfox' },
-- { 'metalelf0/base16-black-metal-scheme' },

-- STATUSLINE
-- { 'nvim-lualine/lualine.nvim', },

-- FILE EXPLORER
-- {
--     "nvim-tree/nvim-tree.lua",
--     version = "*",
--     lazy = false,
--     dependencies = {
--         "nvim-tree/nvim-web-devicons",
--     }
-- },


-- CUSTOM COLORSCHEME
-- { dir = '~/TMP/gruber-darker.nvim/',  as = 'gruber-darker' },

-- SHOW INDENTATION
-- { "lukas-reineke/indent-blankline.nvim",  main = "ibl", opts = {} },
-- { "shellRaining/hlchunk.nvim", event = { "UIEnter" } },

-- LATEX PREVIEW
-- { "lervag/vimtex" },

-- FILE NAVIGATION
-- { "theprimeagen/harpoon" },

-- UNDO TREE
-- { "mbbill/undotree" },

-- ZEN MODE
-- { "folke/zen-mode.nvim" },

-- GIT
-- { "tpope/vim-fugitive" },

-- Agda
-- {
--     "ashinkarov/nvim-agda",
--     lazy = false,
--     config = function()
--         vim.g.nvim_agda_settings = {
--             -- agda = "/usr/local/bin/agda",       -- Location of Agda binary
--             -- agda_args = { "--arg1", "--arg2" }, -- Default arguments to Agda binary
--             debug_p = true -- Turn debug prints on or off
--         }
--     end
-- },

-- COQ
-- {
--     'whonore/Coqtail',
--     init = function()
--         vim.g.loaded_coqtail = 1
--         vim.g["coqtail#supported"] = 0
--     end,
-- },
-- {
--     'tomtomjhj/vscoq.nvim',
--     filetypes = 'coq',
--     dependecies = {
--         'neovim/nvim-lspconfig',
--         'whonore/Coqtail',
--     },
--     opts = {
--         -- vscoq = { ... }
--         -- lsp = { ... }
--     },
-- },

-- NO -- COQ
-- { 'whonore/Coqtail', },
