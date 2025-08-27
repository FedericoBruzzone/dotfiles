------------------------------------------------------
-------------------- LSP CONFIG ----------------------
------------------------------------------------------
local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config
if vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(false, { 0 })
    -- Toggle inlay hints
    vim.keymap.set('n', 'L', function()
        if vim.lsp.inlay_hint.is_enabled() then
            vim.lsp.inlay_hint.enable(false, { 0 })
        else
            vim.lsp.inlay_hint.enable(true, { 0 })
        end
    end)
end


lsp_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lsp_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function()
        -- Enable completion triggered by <c-x><c-o>
        local bufmap = function(mode, lhs, rhs)
            local opts = {} -- buffer = true
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Displays hover information about the symbol under the cursor
        bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

        -- Jump to the definition
        bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

        -- Jump to declaration
        bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

        -- Lists all the implementations for the symbol under the cursor
        bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

        -- Jumps to the definition of the type symbol
        bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

        -- Lists all the references
        bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

        -- Displays a function's signature information
        bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

        -- Renames all references to the symbol under the cursor
        bufmap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')

        -- Selects a code action available at the current cursor position
        bufmap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>')
        bufmap('n', '<C-a>', '<cmd>lua vim.lsp.buf.code_action()<cr>')

        -- Show diagnostics in a floating window
        bufmap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<cr>')

        -- Move to the previous diagnostic
        bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

        -- Move to the next diagnostic
        bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

        -- Show the diagnostic list
        bufmap('n', '<leader>dl', '<cmd>lua vim.diagnostic.setloclist()<cr>')

        -- Format the current buffer
        bufmap('n', '<C-f>', '<cmd>lua vim.lsp.buf.format()<cr>')
        -- bufmap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<cr>')
    end,
})

-- Round the borders of the floating windows
require('lspconfig.ui.windows').default_options.border = 'single'
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

vim.diagnostic.config {
    -- virtual_text = true,
    underline = true,
    virtual_text = {
        -- source = "always",  -- Or "if_many"
        prefix = '●', -- Could be '■', '▎', 'x'
    },
    float = { border = "rounded" },

    -- signs = {
    --     text = {
    --         [vim.diagnostic.severity.ERROR] = '',
    --         [vim.diagnostic.severity.WARN] = '',
    --         [vim.diagnostic.severity.INFO] = '',
    --         [vim.diagnostic.severity.HINT] = '',
    --     },
    --     numhl = {
    --         [vim.diagnostic.severity.WARN] = 'WarningMsg',
    --         [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
    --         [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
    --         [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
    --     },
    -- },
}

-- local sign = function(opts)
--     vim.fn.sign_define(opts.name, {
--         texthl = opts.name,
--         text = opts.text,
--     })
-- end
-- sign({ name = 'DiagnosticSignError', text = "" }) -- '✘'
-- sign({ name = 'DiagnosticSignWarn', text = "" }) -- '▲'
-- sign({ name = 'DiagnosticSignHint', text = "" }) -- '⚑'
-- sign({ name = 'DiagnosticSignInfo', text = '' }) -- ''

------------------------------------------------------
-------------------- CMP CONFIG ----------------------
------------------------------------------------------
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
-- require('luasnip.loaders.from_vscode').lazy_load() -- TOGGLE SNIPPETS

local cmp = require('cmp')
-- local luasnip = require('luasnip') -- TOGGLE SNIPPETS

local select_opts = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    -- snippet = { expand = function(args) luasnip.lsp_expand(args.body) end }, -- TOGGLE SNIPPETS
    sources = {
        { name = 'nvim_lsp', keyword_length = 1 },
        { name = 'path' },
        { name = 'nvim_lua', keyword_length = 1 },
        { name = 'buffer',   keyword_length = 3 },
        -- { name = 'luasnip',  keyword_length = 2 }, -- TOGGLE SNIPPETS
    },
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect',
        -- autocomplete = false
    },
    window = {
        documentation = cmp.config.window.bordered(),
        completion = cmp.config.window.bordered(),
    },
    formatting = {
        fields = { 'abbr', 'menu', 'kind' },
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = 'λ',
                nvim_lua = '',
                buffer = 'Ω',
                path = '🖫',
                -- luasnip = '⋗',
            }
            item.menu = menu_icon[entry.source.name]
            -- Set the fixed width of the completion menu to 60 characters.
            -- fixed_width = 20
            -- Set 'fixed_width' to false if not provided.
            fixed_width = fixed_width or false
            -- Get the completion entry text shown in the completion window. local content = item.abbr Set the fixed completion window width.
            if fixed_width then
                vim.o.pumwidth = fixed_width
            end

            -- Get the width of the current window.
            local win_width = vim.api.nvim_win_get_width(0)

            -- Set the max content width based on either: 'fixed_width'
            -- or a percentage of the window width, in this case 20%.
            -- We subtract 10 from 'fixed_width' to leave room for 'kind' fields.
            local max_content_width = fixed_width and fixed_width - 10 or math.floor(win_width * 0.2)

            local content = item.abbr -- FIXME

            -- Truncate the completion entry text if it's longer than the
            -- max content width. We subtract 3 from the max content width
            -- to account for the "..." that will be appended to it.
            if #content > max_content_width then
                item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
            else
                item.abbr = content .. (" "):rep(max_content_width - #content)
            end
            return item
        end,
    },
    mapping = {
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
        ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),

        ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
        ['<Down>'] = cmp.mapping.select_next_item(select_opts),
        ['<C-Up>'] = cmp.mapping.scroll_docs(-4),
        ['<C-Down>'] = cmp.mapping.scroll_docs(4),

        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        ["<Tab>"] = cmp.mapping(function(fallback)
            -- if luasnip.expand_or_jumpable() then
            --     luasnip.expand_or_jump()
            -- else
            fallback()
            -- end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            -- if luasnip.jumpable(-1) then
            --     luasnip.jump(-1)
            -- else
            fallback()
            -- end
        end, { "i", "s" }),
    }
})

cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(), -- Tab for selection (arrows needed for selecting past items)
    sources = { { name = "buffer" }, { name = "cmdline" }, { name = "path" } }
})

------------------------------------------------------
-------------------- MASON CONFIG --------------------
------------------------------------------------------
local settings = {
    ui = {
        border = "rounded",
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
}

require("mason").setup(settings)

--- MASON LSPCONFIG ---
require("mason-lspconfig").setup({
    automatic_installation = true,
})


require("lspconfig").lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                },
            },
        },
    },
}
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = lsp_defaults.capabilities
capabilities.offsetEncoding = { "utf-8" }

require("lspconfig").clangd.setup {
    capabilities = capabilities,
}
require("lspconfig").pyright.setup {
    root_dir = function(fname)
        return lspconfig.util.root_pattern('pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt',
                'Pipfile', '.git', '__init__.py')(fname) or lspconfig.util.find_git_ancestor(fname) or
            lspconfig.util.path.dirname(fname)
    end,
    settings = {
        pyright = { autoImportCompletion = true, },
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'openFilesOnly',
                useLibraryCodeForTypes = true,
                typeCheckingMode = 'off' }
        }
    },
    capabilities = capabilities,
}
require("lspconfig").ts_ls.setup {}
require("lspconfig").ocamllsp.setup {}

-- TODO: Remove this when the issue is fixed
for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
    local default_diagnostic_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
            return
        end
        return default_diagnostic_handler(err, result, context, config)
    end
end
-- Check if the `CWD` is equal ro `rust`
if vim.fn.expand('%:p:h:t') == "rust" then
    require("lspconfig").rust_analyzer.setup {
        cmd = { "rust-analyzer" }, -- Uses the one in $PATH
        settings = {
            ["rust-analyzer"] = {
                check = {
                    invocationStrategy = "once",
                    overrideCommand = { "python3", "x.py", "check", "--json-output" },
                },
                linkedProjects = {
                    "Cargo.toml",
                    "library/Cargo.toml",
                    "src/tools/x/Cargo.toml",
                    "src/bootstrap/Cargo.toml",
                    "src/tools/rust-analyzer/Cargo.toml",
                    "compiler/rustc_codegen_cranelift/Cargo.toml",
                    "compiler/rustc_codegen_gcc/Cargo.toml",
                },
                rustfmt = {
                    overrideCommand = { "./build/host/rustfmt/bin/rustfmt", "--edition=2021" },
                },
                procMacro = {
                    server = "./build/host/stage0/libexec/rust-analyzer-proc-macro-srv",
                    enable = true,
                },
                cargo = {
                    sysrootSrc = "./library",
                    buildScripts = {
                        enable = true,
                        invocationStrategy = "once",
                        overrideCommand = { "python3", "x.py", "check", "--json-output" },
                    },
                    extraEnv = {
                        RUSTC_BOOTSTRAP = "1",
                    },
                },
                server = {
                    extraEnv = {
                        RUSTUP_TOOLCHAIN = "nightly",
                    },
                },
                rustcSource = "./Cargo.toml",
            },
        },
    }
else
    -- require("lspconfig").rust_analyzer.setup {
    --     settings = {
    --         ["rust-analyzer"] = {
    --             rustcSource = "discover",
    --         }
    --         -- diagnostics = {
    --         --     disabled = { "unresolved-proc-macro" }
    --         -- },
    --     },
    -- }
    require('lspconfig').rust_analyzer.setup {
        cmd = { "rust-analyzer" }, -- Uses the one in $PATH
        settings = {
            ["rust-analyzer"] = {
                cargo = { allFeatures = true },
                checkOnSave = {
                    command = "clippy",
                },
            },
            diagnostics = {
                disabled = { "unresolved-proc-macro" }
            },
        },
    }
end

require("lspconfig").jdtls.setup {}
require("lspconfig").gopls.setup {}
-- require("lspconfig").erlangls.setup {}
require("lspconfig").tinymist.setup {
    settings = {
        exportPdf = "onType"
    }
}
require("lspconfig").texlab.setup {}
require("lspconfig").html.setup {}
require("lspconfig").cssls.setup {}

-- ======== CUSTOM LSP CONFIG ========
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'testlang',
    callback = function()
        vim.lsp.start({
            name = 'testlang',
            cmd = vim.lsp.rpc.connect('127.0.0.1', 5123),
            root_dir = vim.fs.dirname(vim.fs.find({ 'build.gradle' }, { upward = true })[1]),
            -- filetypes = { 'tst', 'nl },
        })
    end,
})

-- ------------ NEVERALNG ------------
-- Socket connection
-- vim.api.nvim_create_autocmd('FileType', {
--         pattern = 'neverlang',
--         callback = function()
--                 vim.lsp.start({
--                         name = 'neverlang',
--                         cmd = vim.lsp.rpc.connect('127.0.0.1', 5123),
--                         root_dir = vim.fs.dirname(vim.fs.find({ 'build.gradle', 'start.lsp' }, { upward = true })[1]),
--                         -- filetypes = { 'tst', 'nl' },
--                 })
--         end,
-- })
-- Pipe connection
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'neverlang',
    callback = function()
        local cmd = {
            "java",
            "-jar",
            -- "/Users/federicobruzzone/Documents/ADAPT-LAB/tesi-dagostino/trunk/neverlang-lsp/neverlang-lsp-implementation/build/libs/neverlang-client.jar"
            -- "/Users/federicobruzzone/Documents/ADAPT-LAB/tesi-dagostino/trunk/examples/neverlang/build/libs/neverlang.compiler.lsp.NeverlangLangLSP-client.jar"
            "/home/fcb/Documents/neverlang-lsp/examples/neverlang/build/libs/neverlang.compiler.lsp.NeverlangLangLSP-client.jar"
        }
        local client = vim.lsp.start({
            name = 'neverlang',
            cmd = cmd,
            root_dir = vim.fs.dirname(vim.fs.find({ 'start.lsp', 'build.gradle' }, { upward = true })[1]),
        })
        vim.lsp.buf_attach_client(0, client)
    end,
})

-- ------------ SIMPLELANG ------------
-- Socket connection (for debug purposes)
-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = 'simplelanguage',
--     callback = function()
--         -- os.execute('./runLSP.sh > /dev/null 2>&1 &') -- UNUSED
--         -- os.execute('./gradlew runLSP -q --console=plain > /dev/null 2>&1 &')
--         -- os.execute('sleep 1')
--
--         vim.lsp.start({
--             name = 'simplelanguage',
--             cmd = vim.lsp.rpc.connect('127.0.0.1', 5123),
--             root_dir = vim.fs.dirname(vim.fs.find({ 'start.lsp', 'build.gradle' }, { upward = true })[1]),
--             -- filetypes = { 'tst', 'nl },
--         })
--     end,
-- })

-- Pipe connection
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'simplelanguage',
    callback = function()
        local cmd = {
            "java",
            "-jar",
            "/home/fcb/dev/SVN/neverlang-commons/trunk/neverlang-commons/simplelang-lsp/build/libs/simplelang-client.jar"
        }
        local client = vim.lsp.start({
            name = 'simplelanguage',
            cmd = cmd,
            root_dir = vim.fs.dirname(vim.fs.find({ 'start.lsp', 'build.gradle' }, { upward = true })[1]),
        })
        vim.lsp.buf_attach_client(0, client)
    end,
})

-- ------------ LITLANG ------------
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'litlang',
    callback = function()
        local cmd = {
            "java",
            "-jar",
            "/home/fcb/dev/SVN/neverlang-commons/trunk/neverlang-commons/litlang/build/libs/litlang-client.jar"
        }
        local client = vim.lsp.start({
            name = 'litlang',
            cmd = cmd,
            root_dir = vim.fs.dirname(vim.fs.find({ 'start.lsp', 'build.gradle' }, { upward = true })[1]),
        })
        vim.lsp.buf_attach_client(0, client)
    end,
})

-- ------------ EXPRLANG ------------
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'exprlang',
    callback = function()
        local cmd = {
            "java",
            "-jar",
            "/home/fcb/dev/SVN/neverlang-commons/trunk/neverlang-commons/exprlang/build/libs/exprlang-client.jar"
        }
        local client = vim.lsp.start({
            name = 'exprlang',
            cmd = cmd,
            root_dir = vim.fs.dirname(vim.fs.find({ 'start.lsp', 'build.gradle' }, { upward = true })[1]),
        })
        vim.lsp.buf_attach_client(0, client)
    end,
})

-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = 'exprlang',
--     callback = function()
--         -- os.execute('./runLSP.sh > /dev/null 2>&1 &') -- UNUSED
--         -- os.execute('./gradlew runLSP -q --console=plain > /dev/null 2>&1 &')
--         -- os.execute('sleep 1')
--
--         vim.lsp.start({
--             name = 'exprlang',
--             cmd = vim.lsp.rpc.connect('127.0.0.1', 5123),
--             root_dir = vim.fs.dirname(vim.fs.find({ 'start.lsp', 'build.gradle' }, { upward = true })[1]),
--             -- filetypes = { 'tst', 'nl },
--         })
--     end,
-- })

-- ------------ Questionnarie Language ------------
-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = 'qn',
--     callback = function()
--         -- os.execute('./runLSP.sh > /dev/null 2>&1 &') -- UNUSED
--         -- os.execute('./gradlew runLSP -q --console=plain > /dev/null 2>&1 &')
--         -- os.execute('sleep 1')
--
--         vim.lsp.start({
--             name = 'qn',
--             cmd = vim.lsp.rpc.connect('127.0.0.1', 5123),
--             root_dir = vim.fs.dirname(vim.fs.find({ 'start.lsp', 'build.gradle' }, { upward = true })[1]),
--             -- filetypes = { 'tst', 'nl },
--         })
--     end,
-- })

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'qn',
    callback = function()
        local cmd = {
            "java",
            "-jar",
            -- "/Users/federicobruzzone/dev/SVN/neverlang-commons/trunk/neverlang-languages/questionnaire-language/questionnaire-language-lang/build/libs/questionnaire-language-client.jar"
            "/Users/federicobruzzone/dev/SVN/neverlang-commons/trunk/neverlang-languages/questionnaire-language/questionnaire-language-client/build/libs/ql.QuestionnarieLanguage-client.jar",
        }
        local client = vim.lsp.start({
            name = 'qn',
            cmd = cmd,
            root_dir = vim.fs.dirname(vim.fs.find({ 'start.lsp', 'build.gradle' }, { upward = true })[1]),
        })
        vim.lsp.buf_attach_client(0, client)
    end,
})
------------------------------------------------------
-------------------- NULL-LS CONFIG ------------------
------------------------------------------------------
-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
-- local diagnostics = null_ls.builtins.diagnostics
null_ls.setup({
    sources = {
        formatting.black,
        formatting.ocamlformat,
        formatting.clang_format,
        formatting.gofumpt,
        formatting.goimports,
        formatting.golines,
        formatting.erlfmt,
    },
    border = "rounded",
    -- on_attach = function(client, bufnr)
    --     if client.supports_method("textDocument/formatting") then
    --         vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    --         vim.api.nvim_create_autocmd("BufWritePre", {
    --             group = augroup,
    --             buffer = bufnr,
    --             callback = function()
    --                 -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
    --                 vim.lsp.buf.format({ bufnr = bufnr })
    --             end,
    --         })
    --     end
    -- end,
})
