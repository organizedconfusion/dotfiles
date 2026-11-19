-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

-- Load all plugins
-- See lua/plugins folder for configurations
vim.pack.add {
    { src = 'https://github.com/catppuccin/nvim' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },
    { src = 'https://github.com/nvim-mini/mini.nvim' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
        version = 'main'
    },
    { src = 'https://github.com/rafamadriz/friendly-snippets' },
    { src = 'https://github.com/mfussenegger/nvim-dap' },
    { src = 'https://github.com/igorlfs/nvim-dap-view' },
    { src = 'https://github.com/hat0uma/csvview.nvim' },
    { src = 'https://github.com/windwp/nvim-autopairs'},
    { src = 'https://github.com/folke/snacks.nvim'},
}

require('config.options')
require('config.clean_mode')
require('config.keymaps')
require('config.lsp')
require('plugins.gitsigns')
require('plugins.mini')
require('plugins.treesitter')
require('plugins.dap')
require('plugins.csvview')
require('plugins.nvim-autopairs')
require('plugins.snacks')
require('config.colorscheme')
require('plugins.lualine')

-- AI tools (copilot, plenary, codecompanion, render-markdown): comment out to disable
require('ai')
