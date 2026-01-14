-- Terminal options
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
-- Remove numbers in terminal mode
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    command = "setlocal nonumber norelativenumber"
})


-- Move line up in visual mode
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<M-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
-- Move line down in visual mode
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<M-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("v", "p", [["_dP]], { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Copy to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.api.nvim_set_keymap('n', '<ESC>u', ':nohlsearch<CR>', { noremap = true, silent = true })

-- resize with shift + arrow
vim.api.nvim_set_keymap('n', '<S-Up>', ':resize +2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Down>', ':resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true })


-- Keybind to switch between background dark and light
local function toggle_background()
    if vim.o.background == "dark" then
        vim.o.background = "light"
    else
        vim.o.background = "dark"
    end
    print("Background: " .. vim.o.background)
end
vim.keymap.set('n', '<leader>cb', toggle_background, { desc = "Toggle background (light/dark)" })
