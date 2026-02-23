-- [[ Colorscheme ]]

vim.opt.termguicolors = true
vim.opt.background = 'dark'

require('gruvbox').setup({
    contrast = ''
})

vim.cmd('colorscheme gruvbox')

-- Get Normal bg, lighten and apply to ColorColumn
local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
local bg = normal.bg
if bg then
    local band, rshift, lshift = bit.band, bit.rshift, bit.lshift

    local r = band(rshift(bg, 16), 0xFF)
    local g = band(rshift(bg, 8), 0xFF)
    local b = band(bg, 0xFF)

    local function lighten(c, amt)
        return math.min(255, math.floor(c + (255 - c) * amt + 0.5))
    end

    local lighten_amt = 0.01;
    local lr, lg, lb = lighten(r, lighten_amt), lighten(g, lighten_amt), lighten(b, lighten_amt)
    local lighter_bg = lshift(lr, 16) + lshift(lg, 8) + lb

    vim.api.nvim_set_hl(0, 'ColorColumn', { bg = lighter_bg })
end


vim.api.nvim_set_hl(0, 'TreesitterContext', {
    bg = vim.api.nvim_get_hl(0, { name = 'NormalFloat' }).bg,
    blend = 0
})

vim.api.nvim_set_hl(0, 'MiniPickBorderText', { link = 'MiniPickNormal' })
vim.api.nvim_set_hl(0, 'MiniPickPrompt', { link = 'MiniPickNormal' })

vim.api.nvim_set_hl(0, 'MiniFilesTitle', {
    fg = vim.api.nvim_get_hl(0, { name = 'MiniFilesTitle' }).fg,
    bg = vim.api.nvim_get_hl(0, { name = 'MiniFilesNormal' }).bg,
})

vim.api.nvim_set_hl(0, 'MiniFilesTitleFocused', {
    fg = vim.api.nvim_get_hl(0, { name = 'MiniFilesTitleFocused' }).fg,
    bg = vim.api.nvim_get_hl(0, { name = 'MiniFilesNormal' }).bg,
    bold = true,
})

vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })

vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { link = 'DiagnosticWarn' })
vim.api.nvim_set_hl(0, 'DiagnosticSignError', { link = 'DiagnosticError' })
vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { link = 'DiagnosticInfo' })
vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { link = 'DiagnosticHint' })

vim.opt.winblend = 10
vim.opt.pumblend = 10
