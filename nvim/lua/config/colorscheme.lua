-- [[ Colorscheme ]]

vim.opt.termguicolors = true
vim.opt.background = 'dark'

require('gruvbox').setup({
    contrast = ''
})

vim.g.gruvbox_material_background = 'medium'
vim.g.gruvbox_material_foreground = 'material'
vim.g.gruvbox_material_enable_bold = '1'
vim.g.gruvbox_material_transparent_background = '0'

-- vim.cmd('colorscheme gruvbox')
vim.cmd('colorscheme gruvbox-material')

vim.api.nvim_set_hl(0, 'TreesitterContext', {
    bg = vim.api.nvim_get_hl(0, { name = 'NormalFloat' }).bg
})

vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })

vim.api.nvim_set_hl(0, 'FloatTitle', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
vim.api.nvim_set_hl(0, 'MiniPickPromptPrefix', { link = 'MiniPickPrompt' })
vim.api.nvim_set_hl(0, 'MiniPickPromptCaret', { link = 'MiniPickPrompt' })
vim.api.nvim_set_hl(0, 'MiniFilesTitle', { link = 'FloatTitle' })

vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { link = 'DiagnosticWarn' })
vim.api.nvim_set_hl(0, 'DiagnosticSignError', { link = 'DiagnosticError' })
vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { link = 'DiagnosticInfo' })
vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { link = 'DiagnosticHint' })

vim.api.nvim_set_hl(0, 'debugPC', { link = 'DiffAdd' })

vim.api.nvim_set_hl(0, 'DiffText', { bg = '#15515D' })

