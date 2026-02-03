
-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

-- [[ PLUGINS ]]
vim.g.vimwiki_list = {
    {
        path = "~/vimwiki/",
        syntax = "markdown",
        ext = ".md",
        path_space_char = '_'
    },
}
vim.pack.add {
    {src = "https://github.com/ellisonleao/gruvbox.nvim"},
    {src = "https://github.com/lewis6991/gitsigns.nvim"},
    {src = "https://github.com/mason-org/mason.nvim"},
    {src = "https://github.com/neovim/nvim-lspconfig"},
    {src = "https://github.com/nvim-lualine/lualine.nvim"},
    {src = "https://github.com/nvim-mini/mini.files"},
    {src = "https://github.com/nvim-mini/mini.icons"},
    {src = "https://github.com/nvim-mini/mini.pairs"},
    {src = "https://github.com/nvim-mini/mini.pick"},
    {src = "https://github.com/nvim-mini/mini.surround"},
    {src = "https://github.com/nvim-treesitter/nvim-treesitter"},
    {src = "https://github.com/nvim-treesitter/nvim-treesitter-context"},
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
        version = 'main'
    },
    {src = "https://github.com/vimwiki/vimwiki"},
}
require('lualine').setup({
    theme = 'auto'
})
require("mason").setup()
require("mini.files").setup()
require("mini.icons").setup()
require("mini.pairs").setup()
require("mini.pick").setup()
require("mini.surround").setup()
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

require("treesitter-context").setup({
    max_lines = 2
})

require("nvim-treesitter-textobjects").setup {
    select = {
        lookahead = true,
    },
}

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
    on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal({']c', bang = true})
            else
                gitsigns.nav_hunk('next')
            end
        end)

        map('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal({']c', bang = true})
            else
                gitsigns.nav_hunk('prev')
            end
        end)

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)
        map('n', '<leader>hp', gitsigns.preview_hunk)
        map('n', '<leader>hd', gitsigns.diffthis)
    end
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
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "FloatTitle", { link = "NormalFloat" })
-- Manually put in gruvbox NormalFloat bg color here with no blend
vim.api.nvim_set_hl(0, "TreesitterContext", { bg = '#3c3836', blend = 0 })
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
vim.opt.breakindent = true


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
vim.diagnostic.config({
    jump = { float = true }
})


-- [[ KEYMAPPINGS ]]
-- See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

vim.keymap.set('n', '<leader>wf', function()
    vim.cmd("write")
end, opts)
vim.keymap.set('n', '<leader>wo', function()
    vim.cmd("write")
    vim.cmd("source")
end, opts)
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
vim.keymap.set('n', '<leader>hh', ':Pick help<CR>')
vim.keymap.set('n', '<leader>g', ':Pick grep_live<CR>')
vim.keymap.set('n', '<leader>e', ':lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>')
vim.keymap.set('n', '<leader>E', ':lua MiniFiles.open()<CR>')
vim.keymap.set('n', '<leader>ad', function()
    vim.diagnostic.setloclist({open = true})
end, opts)
vim.keymap.set('n', '<leader>d', function()
    vim.diagnostic.open_float()
end, opts)
vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump({count = 1, wrap = true})
end, opts)
vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump({count = -1, wrap = true})
end, opts)
vim.keymap.set(
    'n',
    '<leader>t',
    function()
        local today = vim.fn.strftime("# %Y-%m-%d")
        vim.api.nvim_put({ today }, "c", true, true)
    end
)
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
    end,
})

-- Select keymaps
vim.keymap.set({ "x", "o" }, "am", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "im", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "aa", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@parameter.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ia", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@parameter.inner", "textobjects")
end)

-- Move keymaps
-- move by function
vim.keymap.set({ "n", "x", "o" }, "]m", function()
    require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[m", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]M", function()
    require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[M", function()
    require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
end)
-- move by class
vim.keymap.set({ "n", "x", "o" }, "]]", function()
    require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[[", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "][", function()
    require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[]", function()
    require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
end)
-- other moves
vim.keymap.set({ "n", "x", "o" }, "]o", function()
    require("nvim-treesitter-textobjects.move").goto_next_start({"@loop.outer"}, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[o", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start({"@loop.outer"}, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]a", function()
    require("nvim-treesitter-textobjects.move").goto_next_start({"@parameter.inner"}, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[a", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start({"@parameter.inner"}, "textobjects")
end)

-- Swap keymaps
vim.keymap.set("n", "<leader>a", function()
    require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
end)
vim.keymap.set("n", "<leader>A", function()
    require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner"
end)

-- Tresitter repeat movements thee vim way: ; goes to the direction you were moving.
local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

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

