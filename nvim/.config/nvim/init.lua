-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

-- [[ Plugins ]]
-- Install and load all plugins (vim.pack clones them on first launch).
-- Each plugin is configured in lua/plugins/. AI tooling is added in lua/ai/.
vim.pack.add {
    -- Appearance
    { src = 'https://github.com/catppuccin/nvim' },
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },

    -- Editing, navigation and utilities
    { src = 'https://github.com/nvim-mini/mini.nvim' },
    { src = 'https://github.com/folke/snacks.nvim' },
    { src = 'https://github.com/windwp/nvim-autopairs' },
    { src = 'https://github.com/rafamadriz/friendly-snippets' },
    { src = 'https://github.com/hat0uma/csvview.nvim' },

    -- Language support
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
        version = 'main',
    },

    -- Git
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },

    -- Debugging
    { src = 'https://github.com/mfussenegger/nvim-dap' },
    { src = 'https://github.com/igorlfs/nvim-dap-view' },
}

-- [[ Core configuration ]]
-- Options, keymaps and LSP; clean_mode is required first because options depends on it
require('config.options')
require('config.clean_mode')
require('config.keymaps')
require('config.lsp')

-- [[ Plugin configuration ]]
require('plugins.gitsigns')
require('plugins.mini')
require('plugins.treesitter')
require('plugins.dap')
require('plugins.csvview')
require('plugins.nvim-autopairs')
require('plugins.snacks')

-- Loaded after the plugins above so the colorscheme and statusline can build on them
require('config.colorscheme')
require('plugins.lualine')

-- [[ AI tools ]]
-- copilot, plenary, codecompanion, render-markdown: comment out to disable
require('ai')
