local navic = require("nvim-navic")

require('lualine').setup({
    -- options = {
    -- section_separators = { left = '', right = '' },
    -- component_separators = { left = '', right = '' },
    --
    -- section_separators = { left = '', right = '' },
    -- component_separators = { left = '', right = '' },
    -- },
    sections = {
        lualine_c = {
            {
                function()
                    return navic.get_location()
                end,
                cond = function()
                    return navic.is_available()
                end
            },
        }
    },
    -- OR in winbar
    winbar = {
        lualine_c = {
            {
                function()
                    return navic.get_location()
                end,
                cond = function()
                    return navic.is_available()
                end
            },
        }
    }
})
