-- [[ Colorscheme ]]

vim.opt.termguicolors = true
vim.opt.background = 'dark'

require('gruvbox').setup({
    contrast = ''
})

vim.cmd('colorscheme gruvbox')

vim.api.nvim_set_hl(0, 'TreesitterContext', { 
    bg = vim.api.nvim_get_hl(0, { name = 'NormalFloat' }).bg
})
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })

vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { link = 'DiagnosticWarn' })
vim.api.nvim_set_hl(0, 'DiagnosticSignError', { link = 'DiagnosticError' })
vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { link = 'DiagnosticInfo' })
vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { link = 'DiagnosticHint' })

