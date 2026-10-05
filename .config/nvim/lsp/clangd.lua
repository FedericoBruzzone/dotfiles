return {
    cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--header-insertion=never',
        '--completion-style=detailed',
    },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' }, -- 'pov'
    root_markers = { 'compile_commands.json', '.clangd', 'configure.ac', 'Makefile', '.git', },
    init_options = {
        fallbackFlags = { '-std=c23' }, -- Default to C23
    },
}
