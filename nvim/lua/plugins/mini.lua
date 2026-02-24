-- [[ Mini setup ]]
-- This file used for all mini plugins

require('mini.files').setup()
require('mini.icons').setup()
require('mini.pairs').setup()
require('mini.pick').setup({
    window = {
        config = {
            width = 120,
        }
    }
})
require('mini.surround').setup()
require('mini.snippets').setup()
require('mini.completion').setup({
    window = {
        info = { border = 'rounded' },
        signature = { border = 'rounded' },
    }
})

-- Keymaps
vim.keymap.set('n', '<leader>f', ':Pick files<CR>')
vim.keymap.set('n', '<leader>b', ':Pick buffers<CR>')
vim.keymap.set('n', '<leader>hh', ':Pick help<CR>')
vim.keymap.set('n', '<leader>g', ':Pick grep_live<CR>')
vim.keymap.set('n', '<leader>e', ':lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>')
vim.keymap.set('n', '<leader>E', ':lua MiniFiles.open()<CR>')
