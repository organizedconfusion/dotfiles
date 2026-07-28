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

require('everforest').setup({
    background = 'medium',
    transparent_background_level = 0
})

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        if vim.g.colors_name == "everforest" then
            vim.api.nvim_set_hl(0, "Visual", {
                bg = "#4b545a",
            })
        end

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

       vim.api.nvim_set_hl(0, 'DiffText', { bg = '#49616a' })
    end,
})

-- vim.cmd('colorscheme gruvbox')
-- vim.cmd('colorscheme gruvbox-material')
vim.cmd('colorscheme everforest')


