-- [[ LSP Configuration ]]

-- Add LSP
vim.lsp.enable({ 'clangd', 'lua_ls', 'pyright', 'texlab' })

-- Configure LSP
vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--query-driver=/home/sean/common/gcc/ubuntu/7.3/bin",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--fallback-style=none"
    },
})

-- Keymaps
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'grn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set({ 'n', 'x' }, '<leader>cf', vim.lsp.buf.format, opts)
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

