-- [[ LSP Configuration ]]

-- Configure LSP
vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--query-driver=" ..
            "/home/sean/common/gcc/ubuntu/7.3/bin/arm-none-eabi-gcc," ..
            "/home/sean/common/gcc/ubuntu/7.3/bin/arm-none-eabi-g++",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=never",
        "--completion-style=detailed",
        "--fallback-style=none",
        "--log=error"
    },
})

vim.lsp.config("pyright", {
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
                typeCheckingMode = "basic", -- or "strict"
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace", -- or "openFilesOnly"
            },
        },
    },
})

vim.lsp.config("ruff", {
  init_options = {
    settings = {
      organizeImports = true,
    },
  },
})

-- Add LSP
vim.lsp.enable({ 'clangd', 'lua_ls', 'pyright', 'texlab', 'ruff' })


-- Keymaps
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set({ 'n', 'x' }, '<leader>cf', vim.lsp.buf.format, opts)
        vim.keymap.set('n', '<leader>ch', function()
            local enabled = vim.lsp.inlay_hint.is_enabled()
            vim.lsp.inlay_hint.enable(not enabled)
        end, opts)
        if vim.wo.diff then
            vim.diagnostic.enable(false, { bufnr = args.buf })
        end
    end,
})

-- Other Options
vim.diagnostic.config({
  jump = {
    on_jump = function()
      vim.diagnostic.open_float(0, { focus = false })
    end,
  },
})

