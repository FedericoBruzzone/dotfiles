return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
    },
    config = function()
        local cmp = require("cmp")

        cmp.setup({
            preselect = cmp.PreselectMode.Item, -- <— do not select the first item
            completion = { completeopt = "menu,menuone,noinsert" },
            window = {
                completion = cmp.config.window.bordered({
                    border = "rounded",
                }),
                documentation = cmp.config.window.bordered({
                    border = "rounded",
                }),
            },
            formatting = {
                fields = { "abbr", "kind", "menu" },
                format = function(entry, vim_item)
                    local max_width = 50
                    if string.len(vim_item.abbr) > max_width then
                        vim_item.abbr = string.sub(vim_item.abbr, 1, max_width) .. "…"
                    end
                    return vim_item
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<CR>"]      = cmp.mapping.confirm({ select = false }),
                ["<C-e>"]     = cmp.mapping.abort(),
                ["<C-Space>"] = cmp.mapping.complete(), -- manual trigger if you want it
                ["<C-n>"]     = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                ["<C-p>"]     = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                ["<C-f>"]     = cmp.mapping.scroll_docs(4),
                ["<C-u>"]     = cmp.mapping.scroll_docs(-4),
                -- ["<Tab>"]     = cmp.mapping(function(fallback)
                --     if cmp.visible() then cmp.select_next_item() else fallback() end
                -- end, { "i", "s" }),
                -- ["<S-Tab>"]   = cmp.mapping(function()
                --     if cmp.visible() then cmp.select_prev_item() end
                -- end, { "i", "s" }),
            }),
            sources = {
                { name = "nvim_lsp" },
                { name = "path" },
                { name = "buffer",  keyword_length = 3 },
            },
        })

        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(), -- Tab for selection (arrows needed for selecting past items)
            sources = { { name = "buffer" }, { name = "cmdline" }, { name = "path" } }
        })
    end,
}
