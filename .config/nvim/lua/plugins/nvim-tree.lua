return {
    -- https://docs.rockylinux.org/10/books/nvchad/nvchad_ui/nvimtree/
    -- <S-i> will toggle visibility of hidden files
    -- <S-h> will toggle visibility of dotfiles
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        local nvimtree = require("nvim-tree")
        nvimtree.setup({
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
    end,
    keys = {
        {
            "<D-b>",
            ":NvimTreeToggle<CR>",
            mode = { "n" },
            desc = "Toggle file explorer",
        },
        {
            "<leader>r",
            ":NvimTreeRefresh<CR>",
            mode = { "n" },
            desc = "Refresh file explorer"
        },
        -- {
        --     "<leader>n",
        --     ":NvimTreeFindFileToggle<CR>",
        --     mode = { "n" },
        --     desc = "Toggle file explorer on current file",
        -- },
        -- {
        --     "<leader>ec",
        --     ":NvimTreeCollapse<CR>",
        --     mode = { "n" },
        --     desc = "Collapse file explorer",
        -- },
    },
}
