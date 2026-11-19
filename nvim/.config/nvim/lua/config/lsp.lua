-- [[ LSP Configuration ]]
-- Servers are not installed by this config; install them separately (e.g. through the system package manager)

-- [[ Server settings ]]

-- C/C++: background indexing, clang-tidy diagnostics, no automatic #include insertion
vim.lsp.config('clangd', {
    cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--header-insertion=never',
        '--completion-style=detailed',
        '--fallback-style=none',
        '--log=error',
    },
})

-- Python: type checking and navigation (linting and formatting come from ruff)
vim.lsp.config('pyright', {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        '.git',
    },

    settings = {
        python = {
            analysis = {
                typeCheckingMode = 'basic', -- or 'strict'
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'workspace', -- or 'openFilesOnly'
            },
        },
    },
})

-- Lua: treat `vim` as a known global when editing this config
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
        },
    },
})

-- Python linting, formatting and import sorting
vim.lsp.config('ruff', {
    init_options = {
        settings = {
            organizeImports = true,
        },
    },
})

-- [[ Enabled servers ]]
vim.lsp.enable({ 'clangd', 'lua_ls', 'pyright', 'texlab', 'ruff' })

-- [[ Buffer setup on attach ]]
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('config_lsp', { clear = true }),
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- Buffer-local keymaps
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
            vim.tbl_extend('force', opts, { desc = 'Go to definition.' }))
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
            vim.tbl_extend('force', opts, { desc = 'Go to declaration.' }))
        vim.keymap.set({ 'n', 'x' }, '<leader>cf', vim.lsp.buf.format,
            vim.tbl_extend('force', opts, { desc = 'Format the buffer or selection.' }))

        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- Let pyright own hover; ruff's hover would duplicate it
        if client and client.name == 'ruff' then
            client.server_capabilities.hoverProvider = false
        end

        -- Highlight other references to the symbol under the cursor once the cursor rests,
        -- and clear them as soon as it moves or the mode changes
        if client and client:supports_method('textDocument/documentHighlight', bufnr) then
            local group = vim.api.nvim_create_augroup('lsp_document_highlight_' .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd('CursorHold', {
                group = group,
                buffer = bufnr,
                callback = function()
                    if not require('config.clean_mode').is_active() then
                        vim.lsp.buf.document_highlight()
                    end
                end,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'ModeChanged' }, {
                group = group,
                buffer = bufnr,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
})

-- [[ Diagnostics ]]

-- Open the diagnostic float without focusing it after jumping to a diagnostic
vim.diagnostic.config({
    jump = {
        on_jump = function()
            vim.diagnostic.open_float(0, { focus = false })
        end,
    },
})

