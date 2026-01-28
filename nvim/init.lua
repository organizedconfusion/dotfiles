
-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

-- [[ PLUGINS ]]
vim.pack.add {
    {src = "https://github.com/machakann/vim-sandwich"},
    {src = "https://github.com/nvim-lualine/lualine.nvim"},
    {src = "https://github.com/ellisonleao/gruvbox.nvim"},
    {src = "https://github.com/echasnovski/mini.pick"},
    {src = "https://github.com/mason-org/mason.nvim"},
    {src = "https://github.com/neovim/nvim-lspconfig"},
    {src = "https://github.com/nvim-mini/mini.files"},
    {src = "https://github.com/nvim-treesitter/nvim-treesitter"},
    {src = "https://github.com/lewis6991/gitsigns.nvim"},
}
require('lualine').setup({
    theme = 'auto'
})
require("mason").setup()
require("mini.pick").setup()
require("mini.files").setup()
local langs = {
    'bash',
    'c',
    'cmake',
    'comment',
    'cpp',
    'csv',
    'diff',
    'git_config',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'json',
    'linkerscript',
    'lua',
    'make',
    'markdown',
    'markdown_inline',
    'python',
    'vim',
    'vimdoc',
    'yaml',
}

for _, lang in ipairs(langs) do
    require("nvim-treesitter").install(lang)
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = langs,
    callback = function(args)
        vim.treesitter.start(args.buf)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
        vim.wo.foldlevel = 99
    end,
})

require("gitsigns").setup({
    signs = {
        add          = { text = '+' },
        change       = { text = '┃' },
        delete       = { text = '-' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signs_staged = {
        add          = { text = '+' },
        change       = { text = '┃' },
        delete       = { text = '-' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
})

-- [[ COLORSCHEME ]]
vim.opt.termguicolors = true
vim.opt.background = "dark"
require("gruvbox").setup({
    contrast = "hard"
})
vim.cmd([[colorscheme gruvbox]])
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticSignError", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn",  { link = "DiagnosticWarn" })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo",  { link = "DiagnosticInfo" })
vim.api.nvim_set_hl(0, "DiagnosticSignHint",  { link = "DiagnosticHint" })
vim.api.nvim_set_hl(0, "MiniPickNormal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "MiniPickBorder", { bg = "NONE" })
vim.api.nvim_set_hl(0, "MiniFilesBorder", { bg = "NONE" })
vim.api.nvim_set_hl(0, "MiniFilesNormal", { bg = "NONE" })
vim.opt.winblend = 12
vim.opt.pumblend = 12


-- [[ VIM UI ]]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.scrolloff = 5
vim.opt.ruler = true
vim.opt.list = false
vim.opt.listchars:append('space:·')
vim.opt.visualbell = true
vim.opt.showmatch = true
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.opt.clipboard = 'unnamedplus'
  end,
})


-- [[ TEXT FORMATTING ]]
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.linebreak = true
vim.opt.wrap = false


-- [[ LSP ]]
vim.lsp.enable({'clangd', 'lua_ls'})
vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed"
    },
})


-- [[ KEYMAPPINGS ]]
-- See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', '*', '*zz')
vim.keymap.set('n', '#', '#zz')
vim.keymap.set('n', 'g*', 'g*zz')
vim.keymap.set('n', 'g#', 'g#zz')
vim.keymap.set('n', '<C-o>', '<C-o>zz')
vim.keymap.set('n', '<C-i>', '<C-i>zz')
vim.keymap.set('n', '<leader><leader>', '<cmd>noh<CR>')
vim.keymap.set({'i', 'v'}, 'jk', '<esc>')
vim.keymap.set('n', '<leader>f', ':Pick files<CR>')
vim.keymap.set('n', '<leader>b', ':Pick buffers<CR>')
vim.keymap.set('n', '<leader>e', ':lua MiniFiles.open()<CR>')
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, opts)
        vim.keymap.set('n', '[d', function()
            vim.diagnostic.goto_prev()
            vim.diagnostic.open_float()
        end, opts)
        vim.keymap.set('n', ']d', function()
            vim.diagnostic.goto_next()
            vim.diagnostic.open_float()
        end, opts)
    end,
})


-- [[ AUTOCOMMANDS ]].
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", { command = [[set norelativenumber]] })
vim.api.nvim_create_autocmd("InsertLeave", { command = [[set relativenumber]] })

