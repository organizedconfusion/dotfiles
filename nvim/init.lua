-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

-- Load all plugins
-- See lua/plugins folder for configurations
vim.pack.add {
    { src = 'https://github.com/ellisonleao/gruvbox.nvim' },
    { src = 'https://github.com/f4z3r/gruvbox-material.nvim' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },
    { src = 'https://github.com/nvim-mini/mini.files' },
    { src = 'https://github.com/nvim-mini/mini.icons' },
    { src = 'https://github.com/nvim-mini/mini.pairs' },
    { src = 'https://github.com/nvim-mini/mini.pick' },
    { src = 'https://github.com/nvim-mini/mini.surround' },
    { src = 'https://github.com/nvim-mini/mini.snippets' },
    { src = 'https://github.com/nvim-mini/mini.completion' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
    { src = 'https://github.com/vimwiki/vimwiki' },
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
        version = 'main'
    },
    { src = 'https://github.com/vimwiki/vimwiki' },
    { src = 'https://github.com/xiyaowong/virtcolumn.nvim' },
    { src = 'https://github.com/rafamadriz/friendly-snippets' },
}

require('config.options')
require('config.colorscheme')
require('config.keymaps')
require('config.lsp')
require('plugins.gitsigns')
require('plugins.vimwiki')
require('plugins.lualine')
require('plugins.mini')
require('plugins.mason')
require('plugins.treesitter')
require('plugins.termdebug')

