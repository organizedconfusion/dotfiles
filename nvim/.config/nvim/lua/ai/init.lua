-- All AI tooling lives here. Remove `require('ai')` from init.lua to disable.
vim.pack.add {
    { src = 'https://github.com/github/copilot.vim' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/meanderingprogrammer/render-markdown.nvim' },
    {
        src = 'https://github.com/olimorris/codecompanion.nvim',
        version = vim.version.range("^19.0.0")
    },
}

require('ai.codecompanion')
require('ai.render-markdown')
