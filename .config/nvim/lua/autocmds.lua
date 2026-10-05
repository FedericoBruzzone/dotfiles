local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight yanked text
local yank_ns = vim.api.nvim_create_namespace('yank_highlight')
autocmd('TextYankPost', {
    pattern = '*',
    group = augroup('YankHighlight', { clear = true }),
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local r1  = vim.fn.line("'[") - 1
        local r2  = vim.fn.line("']") - 1
        local c1  = vim.fn.col("'[") - 1
        local c2  = vim.fn.col("']")
        vim.api.nvim_buf_clear_namespace(buf, yank_ns, 0, -1)
        for row = r1, r2 do
            vim.api.nvim_buf_add_highlight(buf, yank_ns, 'IncSearch', row,
                row == r1 and c1 or 0,
                row == r2 and c2 or -1)
        end
        vim.defer_fn(function()
            pcall(vim.api.nvim_buf_clear_namespace, buf, yank_ns, 0, -1)
        end, 170)
    end,
})

vim.api.nvim_create_autocmd("QuitPre", {
    callback = function()
        local invalid_win = {}
        local wins = vim.api.nvim_list_wins()
        for _, w in ipairs(wins) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
            if bufname:match("NvimTree_") ~= nil then
                table.insert(invalid_win, w)
            end
        end
        if #invalid_win == #wins - 1 then
            -- Should quit, so we close all invalid windows.
            for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
        end
    end
})
