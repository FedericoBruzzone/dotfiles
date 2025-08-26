-- git clone --depth 1 https://github.com/wbthomason/packer.nvim\ ~/.local/share/nvim/site/pack/packer/start/packer.nvim

-- :so
-- :PackerSync

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

return require("packer").startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- FUZZY FINDER
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    -- or                            , branch = '0.1.x',
    requires = { 'nvim-lua/plenary.nvim' },
    commit = "5a747a9587e4bfc4ae086a38cc679fe54f983b69"
  }

  -- COLORSCHEME
  use { "mcchrish/zenbones.nvim", requires = "rktjmp/lush.nvim" } -- white colorscheme
  use { 'rose-pine/neovim', as = 'rose-pine', }
  use { 'folke/tokyonight.nvim', as = 'tokyonight', }
  use { "catppuccin/nvim", as = "catppuccin" }
  use { 'bluz71/vim-moonfly-colors', as = 'moonfly' }
  use { 'blazkowolf/gruber-darker.nvim', as = 'gruber-darker' }

  -- SYNTAX HIGHLIGHTING
  use { 'nvim-treesitter/nvim-treesitter' }
  use("nvim-treesitter/nvim-treesitter-context")
  -- use("nvim-treesitter/playground")

  -- LSP
  use { "neovim/nvim-lspconfig", }  -- enable LSP
  use { "williamboman/mason.nvim" } -- simple to use language server installer
  use { "williamboman/mason-lspconfig.nvim" }
  -- AUTO COMPLETION
  use { "hrsh7th/nvim-cmp" }             -- The completion plugin
  use { "hrsh7th/cmp-buffer" }           -- buffer completions
  use { "hrsh7th/cmp-path" }             -- path completions
  use { "saadparwaiz1/cmp_luasnip" }     -- snippet completions
  use { "hrsh7th/cmp-nvim-lsp" }         -- LSP completions
  use { "hrsh7th/cmp-nvim-lua" }         -- nvim lua completions
  -- SNIPPETS
  use { "L3MON4D3/LuaSnip" }             --snippet engine
  use { "rafamadriz/friendly-snippets" } -- a bunch of snippets to use


  -- STATUSLINE
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  -- GIT
  use { "lewis6991/gitsigns.nvim" }
  use { "tpope/vim-fugitive" }

  -- FILE NAVIGATION
  use { "theprimeagen/harpoon" }

  -- COMMENT
  use { 'numToStr/Comment.nvim' }

  -- COQ
  use { 'whonore/Coqtail' }

  -- LATEX PREVIEW
  use { "lervag/vimtex" }

  -- MARKDOWN PREVIEW
  use { "iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]() end, }

  -- UNDO TREE
  use { "mbbill/undotree" }

  -- ZEN MODE
  use { "folke/zen-mode.nvim" }

  -- COPILOT
  use { "github/copilot.vim", commit = "f2a4acd62587c62910bda0b79405c585af43c002" }
end)

-- use({
--     "folke/trouble.nvim",
--     config = function()
--         require("trouble").setup {
--             icons = true,
--             -- your configuration comes here
--             -- or leave it empty to use the default settings
--             -- refer to the configuration section below
--         }
--     end
-- })
