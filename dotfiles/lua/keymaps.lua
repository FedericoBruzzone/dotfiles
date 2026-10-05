local keymap = vim.keymap.set
local s = { silent = true }

-- Multicursor VS Code-like: primo press seleziona la parola, press successivi aggiungono la prossima occorrenza
keymap("n", "<C-d>", "viw",  { noremap = true, silent = true, desc = "Multicursor: select current word" })
keymap("x", "<C-d>", "Q",    { remap = true,   silent = true, desc = "Multicursor: add next match" })

vim.g.mapleader = " "
keymap("n", "<space>", "<Nop>")


keymap("t", "<Esc>", "<C-\\><C-N>")                                              -- Exit terminal mode
keymap("n", "<leader>cd", '<cmd>lua vim.fn.chdir(vim.fn.expand("%:p:h"))<CR>')   -- Change directory to the current file's directory
keymap({ "n", "v" }, "<M-Down>", ":m '>+1<CR>gv=gv", s)                          -- Move line down
keymap({ "n", "v" }, "<M-Up>", ":m '<-2<CR>gv=gv", s)                            -- Move line up
keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- Search and replace
keymap("n", "<ESC>u", ":nohlsearch<CR>", s)                                      -- Remove highlighting

-- Resize with arrows
keymap("n", "<S-Up>", ":resize +2<CR>", s)
keymap("n", "<S-Down>", ":resize -2<CR>", s)
keymap("n", "<S-Left>", ":vertical resize -2<CR>", s)
keymap("n", "<S-Right>", ":vertical resize +2<CR>", s)

-- Clipboard
keymap("x", "<leader>p", [["_dP]])
keymap("v", "p", [["_dP]], s)
keymap({ "n", "v" }, "<leader>d", [["_d]])
keymap({ "n", "v" }, "<leader>y", [["+y]])



keymap("n", "<Leader>ex", "<cmd>Ex %:p:h<CR>") -- Open Netrw in the current file's directory
-- Keybind to switch between background dark and light
local function toggle_background()
    if vim.o.background == "dark" then
        vim.o.background = "light"
    else
        vim.o.background = "dark"
    end
end
keymap("n", "<leader>cb", toggle_background)



-- keymap("n", "j", function()
--     return tonumber(vim.api.nvim_get_vvar("count")) > 0 and "j" or "gj"
-- end, { expr = true, silent = true }) -- Move down, but use 'gj' if no count is given
-- keymap("n", "k", function()
--     return tonumber(vim.api.nvim_get_vvar("count")) > 0 and "k" or "gk"
-- end, { expr = true, silent = true }) -- Move up, but use 'gk' if no count is given
