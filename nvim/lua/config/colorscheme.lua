-- [[ Colorscheme ]]

vim.opt.termguicolors = true
vim.opt.background = 'dark'

require('gruvbox').setup({
    contrast = ''
})

require('vague').setup()

vim.cmd('colorscheme gruvbox')
--vim.cmd('colorscheme vague')

vim.api.nvim_set_hl(0, 'TreesitterContext', {
    bg = vim.api.nvim_get_hl(0, { name = 'NormalFloat' }).bg,
    blend = 0
})

--vim.api.nvim_set_hl(0, 'MiniPickBorderText', { link = 'MiniPickNormal' })
--vim.api.nvim_set_hl(0, 'MiniPickPrompt', { link = 'MiniPickNormal' })
--vim.api.nvim_set_hl(0, 'MiniFilesTitle', {
--    fg = vim.api.nvim_get_hl(0, { name = 'MiniFilesTitle' }).fg,
--    bg = vim.api.nvim_get_hl(0, { name = 'MiniFilesNormal' }).bg,
--})
--vim.api.nvim_set_hl(0, 'MiniFilesTitleFocused', {
--    fg = vim.api.nvim_get_hl(0, { name = 'MiniFilesTitleFocused' }).fg,
--    bg = vim.api.nvim_get_hl(0, { name = 'MiniFilesNormal' }).bg,
--    bold = true,
--})

vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })

vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })

vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { link = 'DiagnosticWarn' })
vim.api.nvim_set_hl(0, 'DiagnosticSignError', { link = 'DiagnosticError' })
vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { link = 'DiagnosticInfo' })
vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { link = 'DiagnosticHint' })

pmenu = vim.api.nvim_get_hl(0, { name = 'Pmenu' })
pmenusel = vim.api.nvim_get_hl(0, { name = 'PmenuSel' })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = pmenu.bg, blend = 0 })
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = pmenusel.bg, blend = 0 })

vim.opt.winblend = 12
vim.opt.pumblend = 12
