return {
    "rebelot/kanagawa.nvim",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other plugins
    config = function()
        -- NOTE: you do not need to call setup if you don't want to.
        require('kanagawa').setup({
            compile = false,  -- enable compiling the colorscheme
            undercurl = true, -- enable undercurls
            commentStyle = { italic = true },
            functionStyle = {},
            keywordStyle = { italic = true },
            statementStyle = { bold = true },
            typeStyle = {},
            transparent = false,   -- do not set background color
            dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
            terminalColors = true, -- define vim.g.terminal_color_{0,17}
            colors = {             -- add/modify theme and palette colors
                palette = {},
                theme = {
                    wave = {},
                    lotus = {},
                    dragon = {},
                    all = {
                        -- Remove the background of LineNr, {Sign,Fold}Column and friends
                        ui = {
                            bg_gutter = "none"
                        }
                    }
                },
            },
            overrides = function(colors) -- add/modify highlights
                local theme = colors.theme

                local makeDiagnosticColor = function(color)
                    local c = require("kanagawa.lib.color")
                    return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
                end

                return {
                    -- This will make floating windows look nicer with default borders.
                    NormalFloat                = { bg = "none" },
                    FloatBorder                = { bg = "none" },
                    FloatTitle                 = { bg = "none" },
                    -- Save an hlgroup with dark background and dimmed foreground
                    -- so that you can use it where your still want darker windows.
                    -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
                    NormalDark                 = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
                    -- Popular plugins that open floats will link to NormalFloat by default;
                    -- set their background accordingly if you wish to keep them dark and borderless
                    LazyNormal                 = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
                    MasonNormal                = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

                    -- Block-like modern Telescope UI
                    TelescopeTitle             = { fg = theme.ui.special, bold = true },
                    TelescopePromptNormal      = { bg = theme.ui.bg_p1 },
                    TelescopePromptBorder      = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                    TelescopeResultsNormal     = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                    TelescopeResultsBorder     = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
                    TelescopePreviewNormal     = { bg = theme.ui.bg_dim },
                    TelescopePreviewBorder     = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

                    -- More uniform colors for the popup menu.
                    Pmenu                      = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
                    PmenuSel                   = { fg = "NONE", bg = theme.ui.bg_p2 },
                    PmenuSbar                  = { bg = theme.ui.bg_m1 },
                    PmenuThumb                 = { bg = theme.ui.bg_p2 },

                    -- Tint background of diagnostic messages with their foreground color
                    DiagnosticVirtualTextHint  = makeDiagnosticColor(theme.diag.hint),
                    DiagnosticVirtualTextInfo  = makeDiagnosticColor(theme.diag.info),
                    DiagnosticVirtualTextWarn  = makeDiagnosticColor(theme.diag.warning),
                    DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),


                }
            end,
            theme = "wave",      -- Load "wave" theme
            background = {       -- map the value of 'background' option to a theme
                dark = "dragon", -- try "wave"
                light = "lotus"
            },
        })
        vim.cmd("colorscheme kanagawa-wave")
        -- vim.api.nvim_set_hl(0, "Normal", { bg = "Black" })
        -- vim.api.nvim_set_hl(0, "SignColumn", { bg = "Black" })


        vim.api.nvim_set_keymap('n', '<leader>co2', ":colorscheme kanagawa-wave<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>co1', ":colorscheme kanagawa-dragon<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>co3', ":colorscheme kanagawa-lotus<CR>", { noremap = true, silent = true })
    end
}
