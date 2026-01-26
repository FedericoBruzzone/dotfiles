vim.lsp.config('*', {
    root_markers = { '.git' },
})

vim.diagnostic.config({
    -- virtual_lines = true, -- this gets messy on large code base with tons of errors
    -- Select either virtual lines or text below otherwise it gets messy
    virtual_text = {
        spacing = 4,
        prefix = "●", -- This is fine as a string
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        style  = 'minimal',
        border = 'rounded',
        source = 'if_many',
        header = '',
        prefix = '',
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        }
    }
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local buf    = args.buf
        local map    = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = buf }) end

        map('n', 'K', vim.lsp.buf.hover)
        map('n', 'gd', vim.lsp.buf.definition)
        map('n', 'gD', vim.lsp.buf.declaration)
        map('n', 'gi', vim.lsp.buf.implementation)
        map('n', 'go', vim.lsp.buf.type_definition)
        map('n', 'gr', vim.lsp.buf.references)
        map({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help)
        map('n', '<leader>e', vim.diagnostic.open_float)
        map('n', '<F2>', vim.lsp.buf.rename)
        map({ 'n', 'x' }, '<D-S-i>', function() vim.lsp.buf.format({ async = true }) end)
        map('n', '<D-.>', vim.lsp.buf.code_action)

        local excluded_filetypes = {} -- c = true, cpp = true }
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting')
            and not excluded_filetypes[vim.bo[buf].filetype]
        then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp.format', { clear = false }),
                buffer = buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end
    end,
})

vim.lsp.config['lua_ls'] = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim', 'require' } },
            workspace = {
                checkThirdParty = false,
                -- This is too heavy; the language server takes ages to start.
                -- library = vim.api.nvim_get_runtime_file('', true),
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                },
            },
            telemetry = { enable = false },
        },
    },
}

vim.api.nvim_create_user_command('RustExpandMacro', function()
    local clients = vim.lsp.get_clients({ name = 'rust_analyzer' })
    local client = clients[1]

    if client then
        client:request("rust-analyzer/expandMacro", vim.lsp.util.make_position_params(0, nil), function(err, result)
            if err or not result then return end
            -- vim.print(result)
            -- print(result.expansion)


            local lines = vim.split(result.expansion, "\n")
            local buf = vim.api.nvim_create_buf(false, true)

            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
            vim.api.nvim_set_option_value('filetype', 'rust', { buf = buf })

            vim.cmd("vsplit")
            vim.api.nvim_set_current_buf(buf)
        end)
    end
end, {})

-- Rust via rust-analyzer
vim.lsp.config['rust_analyzer'] = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                -- allFeatures = true
                allTargets = true,
            },
            check = { command = "clippy", }, -- Use Clippy on save
            rustcSource = "discover",        -- To work with rust-src component
            formatting = {
                command = { "rustfmt" }
            },
        },
    },
}

-- C / C++ via clangd
vim.lsp.config['clangd'] = {
    cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--header-insertion=never',
        '--completion-style=detailed',
    },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    root_markers = { 'compile_commands.json', '.clangd', 'configure.ac', 'Makefile', '.git', },
    init_options = {
        fallbackFlags = { '-std=c23' }, -- Default to C23
    },
}

vim.filetype.add({
    extension = {
        h = 'c',
    },
})

if vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(true, { 0 })
    -- Toggle inlay hints
    vim.keymap.set('n', 'L', function()
        if vim.lsp.inlay_hint.is_enabled() then
            vim.lsp.inlay_hint.enable(false, { 0 })
        else
            vim.lsp.inlay_hint.enable(true, { 0 })
        end
    end)
end


vim.lsp.enable("rust_analyzer")
vim.lsp.enable("clangd")
vim.lsp.enable("lua_ls")   -- via Mason
vim.lsp.enable("texlab")   -- via Mason
vim.lsp.enable("tinymist") -- via Mason


vim.api.nvim_create_autocmd('FileType', {
    pattern = 'exprlang',
    callback = function()
        local cmd = {
            "java",
            "-jar",
            "/Users/federicobruzzone/dev/neverlang-commons/trunk/neverlang-commons/exprlang/build/libs/exprlang-client.jar"
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

--- =====Usual common settings for some *unused* local LSP servers=====

-- vim.lsp.config['jsonls'] = {
--     cmd = { 'vscode-json-languageserver', '--stdio' },
--     filetypes = { 'json', 'jsonc' },
--     root_markers = { 'package.json', '.git', 'config.jsonc' },
--     capabilities = caps,
-- }


-- local orig = vim.lsp.util.open_floating_preview
-- ---@diagnostic disable-next-line: duplicate-set-field
-- function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
--     opts            = opts or {}
--     opts.border     = opts.border or 'rounded'
--     opts.max_width  = opts.max_width or 80
--     opts.max_height = opts.max_height or 24
--     opts.wrap       = opts.wrap ~= false
--     return orig(contents, syntax, opts, ...)
-- end
