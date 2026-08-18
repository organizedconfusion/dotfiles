require'nvim-tmux-navigation'.setup({
    disable_when_zoomed = true,
})

vim.keymap.set({'n', 'v', 't'}, "<C-h>", require('nvim-tmux-navigation').NvimTmuxNavigateLeft)
vim.keymap.set({'n', 'v', 't'}, "<C-j>", require('nvim-tmux-navigation').NvimTmuxNavigateDown)
vim.keymap.set({'n', 'v', 't'}, "<C-k>", require('nvim-tmux-navigation').NvimTmuxNavigateUp)
vim.keymap.set({'n', 'v', 't'}, "<C-l>", require('nvim-tmux-navigation').NvimTmuxNavigateRight)
vim.keymap.set({'n', 'v', 't'}, "<C-\\>", require('nvim-tmux-navigation').NvimTmuxNavigateLastActive)
vim.keymap.set({'n', 'v', 't'}, "<C-Space>", require('nvim-tmux-navigation').NvimTmuxNavigateNext)
