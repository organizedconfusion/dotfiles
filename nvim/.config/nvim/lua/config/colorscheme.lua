-- [[ Colorscheme ]]

vim.opt.termguicolors = true
vim.opt.background = 'dark'

require('everforest').setup({
    background = 'medium',
    transparent_background_level = 0
})

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        if vim.g.colors_name == "everforest" then
            vim.api.nvim_set_hl(0, "Visual", { bg = "#4b545a", })
            vim.api.nvim_set_hl(0, 'DiffText', { bg = '#49616a' })
        end

        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })

        vim.api.nvim_set_hl(0, 'FloatTitle', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })

        vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { link = 'DiagnosticWarn' })
        vim.api.nvim_set_hl(0, 'DiagnosticSignError', { link = 'DiagnosticError' })
        vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { link = 'DiagnosticInfo' })
        vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { link = 'DiagnosticHint' })
    end,
})

vim.cmd('colorscheme everforest')


