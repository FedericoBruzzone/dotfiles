vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/saghen/blink.cmp",       version = vim.version.range("^1") },
    { src = "https://github.com/github/copilot.vim" },
    { src = "https://github.com/nvim-tree/nvim-tree.lua" }, { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" }, { src = "https://github.com/nvim-lua/plenary.nvim" }, { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/rmagatti/auto-session" },
    { src = "https://github.com/folke/trouble.nvim" },
    { src = "https://github.com/NeogitOrg/neogit" },
    { src = "https://github.com/sindrets/diffview.nvim" },
    { src = "https://github.com/pwntester/octo.nvim" },
    { src = "https://github.com/linrongbin16/gitlinker.nvim" },
    { src = "https://github.com/akinsho/bufferline.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/AlexvZyl/nordic.nvim" }
})

require('gitsigns').setup({ signcolumn = true })
require("mason").setup({})
require("nvim-autopairs").setup({})
require("auto-session").setup({})
require('nordic').load()
require('trouble').setup({})
require('neogit').setup({ integrations = { diffview = true, telescope = true } })
require('diffview').setup({})
require('octo').setup({ picker = "telescope", enable_builtin = true })
require('gitlinker').setup()
require("bufferline").setup({})
require("lualine").setup({})

local k = vim.keymap.set
k("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" })
k("n", "<leader>oi", "<cmd>Octo issue list<cr>", { desc = "List GitHub Issues" })
k("n", "<leader>op", "<cmd>Octo pr list<cr>", { desc = "List GitHub PRs" })
k("n", "<leader>oP", "<cmd>Octo search pr is:open involves:@me<cr>", { desc = "My GitHub PRs (involved)" })
k("n", "<leader>od", "<cmd>Octo discussion list<cr>", { desc = "List GitHub Discussions" })
k("n", "<leader>on", "<cmd>Octo notification list<cr>", { desc = "List GitHub Notifications" })
k("n", "<leader>os", function()
    require("octo.utils").create_base_search_command({ include_current_repo = true })
end, { desc = "Search GitHub" })
k("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
k("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
k("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false win.position=left<cr>", { desc = "Symbols (Trouble)" })
k("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=left<cr>",
    { desc = "LSP Definitions / references / ... (Trouble)" })

vim.g.copilot_enabled = 0
vim.api.nvim_set_keymap('n', '<leader>ce', ':Copilot enable<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>cd', ':Copilot disable<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-l>', '<Plug>(copilot-accept-word)', { noremap = true, silent = true })

require('blink.cmp').setup({
    enabled = function()
        return vim.bo.buftype ~= 'prompt'
    end,
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
    keymap = {
        preset = "default",
        ['<CR>'] = { 'accept', 'fallback' },
    },

    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "normal",
    },

    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        }
    },

    cmdline = {
        keymap = {
            preset = 'inherit',
            ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
    },

    sources = { default = { "lsp" } }
})

require('nvim-tree').setup({
    diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    view = {
        width = 25,
        -- side = "right",
        -- relativenumber = true,
    },
    renderer = {
        indent_markers = { enable = true, },
        highlight_git = true,
    },
    filters = {
        custom = {},
    },
    git = {
        ignore = false,
    },
    actions = {
        open_file = {
            quit_on_open = false, -- Do not close the tree when opening a file
        },
    },
})

local api = require "nvim-tree.api"
local gopts = { noremap = true, silent = true }
vim.keymap.set("n", "<D-b>", api.tree.toggle, vim.tbl_extend("force", gopts, { desc = "nvim-tree: Toggle" }))
vim.keymap.set("n", "<leader>r", api.tree.reload, vim.tbl_extend("force", gopts, { desc = "nvim-tree: Refresh" }))
vim.keymap.set("n", "<leader>n", api.tree.find_file, vim.tbl_extend("force", gopts, { desc = "nvim-tree: Find File" }))
vim.keymap.set("n", "<leader>ec", api.tree.collapse_all,
    vim.tbl_extend("force", gopts, { desc = "nvim-tree: Collapse All" }))

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<D-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fl', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = "Git branches" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>f.', function() builtin.find_files({ cwd = vim.fn.expand("%:p:h") }) end,
    { desc = "Find files in current file's dir" })
vim.keymap.set('n', '<leader>l.', function() builtin.live_grep({ search_dirs = { vim.fn.expand("%:p:h") } }) end,
    { desc = "Grep in current file's dir" })
vim.keymap.set('n', '<leader>fd',
    function() builtin.find_files({ cwd = vim.fn.input("Dir: ", vim.fn.getcwd(), "dir") }) end,
    { desc = "Find files in prompted dir" })
vim.keymap.set('n', '<leader>ld',
    function() builtin.live_grep({ search_dirs = { vim.fn.input("Dir: ", vim.fn.getcwd(), "dir") } }) end,
    { desc = "Grep in prompted dir" })
