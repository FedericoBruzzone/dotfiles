vim.api.nvim_set_keymap('n', '<M-k>', '<Cmd>lua require("dapui").toggle()<CR>', { noremap = true, silent = true })


-- Terminal options
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
-- Remove numbers in terminal mode
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    command = "setlocal nonumber norelativenumber"
})

-- General key mappings
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.api.nvim_set_keymap('n', '<leader>ce', ':Copilot enable<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>cd', ':Copilot disable<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-L>', '<Plug>(copilot-accept-word)', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move line up in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
-- Move line down in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- vim.keymap.set("n", "J", "mzJ`z") -- Only for VIM

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("v", "p", [["_dP]], { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Paste at the end of the line
vim.keymap.set("n", "<leader>pe", "A <Esc>p")

-- next greatest remap ever
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- vim.keymap.set("n", "<leader>ppv", ":Lex 20<CR>")
vim.api.nvim_set_keymap('n', '<ESC>u', ':nohlsearch<CR>', { noremap = true, silent = true })

vim.keymap.set({ 'n', 'v' }, "\\", "%", { noremap = true, silent = true })

-- resize with shift + arrow
vim.api.nvim_set_keymap('n', '<S-Up>', ':resize +2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Down>', ':resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Left>', ':vertical resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Right>', ':vertical resize +2<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true, silent = true })

-- Go to definition in splitted right window
vim.keymap.set("n", "gw", "<cmd>vsp | lua vim.lsp.buf.definition()<CR>") -- vim.api.nvim_set_keymap('n', '<leader>gd', '<C-w>v<C-]><C-w>h', { noremap = true, silent = true })






function ToggleLineNumbers()
    if vim.wo.number then
        vim.opt.nu = false
        vim.opt.relativenumber = false
    else
        vim.opt.nu = true
        vim.opt.relativenumber = true
    end
end

vim.api.nvim_set_keymap("n", "<leader>tn", ":lua ToggleLineNumbers()<CR>", { noremap = true, silent = true })

function Surround(t)
    local open_char = vim.fn.input("Surround with: ")
    local closed_char = nil
    if open_char == "(" then closed_char = ")" end
    if open_char == "[" then closed_char = "]" end
    if open_char == "{" then closed_char = "}" end
    if open_char == "<" then closed_char = ">" end
    if open_char == "'" then closed_char = "'" end
    if open_char == '"' then closed_char = '"' end
    if open_char == "`" then closed_char = "`" end
    if open_char == "/" then closed_char = "/" end
    if open_char == "|" then closed_char = "|" end

    if t == "w" then
        vim.cmd("normal! ciw" .. open_char)
    elseif t == "W" then
        vim.cmd("normal! ciW" .. open_char)
    elseif t == "$" then
        vim.cmd("normal! c$" .. open_char)
    end
    vim.cmd("normal! p")
    vim.cmd("normal! a" .. closed_char)
    vim.cmd("normal! a")
end

vim.api.nvim_set_keymap("n", "<leader>sw", ":lua Surround('w')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>sW", ":lua Surround('W')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>s$", ":lua Surround('$')<CR>", { noremap = true, silent = true })

function Align()
    local c = vim.fn.input("Align with: ")
    local start = vim.fn.col("'<")
    local max = 0
    for i = vim.fn.line("'<"), vim.fn.line("'>") do
        local line = vim.fn.getline(i)
        local equals = string.find(line, c, start)
        if equals then
            local length = equals - start
            if length > max then
                max = length
            end
        end
    end
    for i = vim.fn.line("'<"), vim.fn.line("'>") do
        local line = vim.fn.getline(i)
        local equals = string.find(line, c, start)
        if equals then
            local length = equals - start
            local spaces = max - length
            local spaces_string = string.rep(" ", spaces)
            local new_line = string.sub(line, 0, equals - 1) .. spaces_string .. string.sub(line, equals)
            vim.fn.setline(i, new_line)
        end
    end
end

vim.api.nvim_set_keymap("v", "<leader>aw", ":lua Align()<CR>", { noremap = true, silent = true })

function HighlightWordUnderCursor()
    local disabled_ft = { "qf", "fugitive", "nerdtree", "gundo", "diff", "fzf", "floaterm" }
    local ft = vim.bo.filetype
    local bt = vim.bo.buftype
    local diff = vim.wo.diff

    if diff or bt == "terminal" or vim.tbl_contains(disabled_ft, ft) then
        return
    end

    local col = vim.fn.col(".")
    local line = vim.fn.getline(".")
    local char = line:sub(col, col)

    if not char:match("[%p%s]") then
        -- vim.cmd("hi MatchWord guibg=#222222") -- #3b404a -- vim.cmd("hi MatchWord gui=undercurl guibg=#3b404a")
        -- vim.cmd("hi MatchWord gui=reverse")
        vim.cmd("hi MatchWord gui=underline")
        vim.cmd("match MatchWord /\\V\\<" .. vim.fn.expand("<cword>") .. "\\>/")
    else
        vim.cmd("match none")
    end
end

vim.api.nvim_create_augroup("MatchWord", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, { group = "MatchWord", callback = HighlightWordUnderCursor })

-- GUI FONT SIZE
if vim.fn.has("gui_running") then
    -- vim.cmd("set guifont=PragmataProMonoLiga\\ Nerd\\ Font:h12")
    -- vim.opt.guifont = "PragmataProMonoLiga Nerd Font:h12"
    vim.opt.guifont = "Iosevka Nerd Font Mono:h20"
end

local fontsize = 20 -- 12
function AdjustFontSize(amount)
    fontsize = fontsize + amount
    vim.opt.guifont = "Iosevka Nerd Font Mono:h" .. fontsize
end

vim.api.nvim_set_keymap('n', '<C-ScrollWheelUp>', [[:lua AdjustFontSize(1)<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-ScrollWheelDown>', [[:lua AdjustFontSize(-1)<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-ScrollWheelUp>', [[<Esc>:lua AdjustFontSize(1)<CR>a]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-ScrollWheelDown>', [[<Esc>:lua AdjustFontSize(-1)<CR>a]],
    { noremap = true, silent = true })
