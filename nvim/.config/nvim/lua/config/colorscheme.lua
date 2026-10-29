-- [[ Colorscheme ]]

vim.opt.termguicolors = true
vim.opt.background = 'dark'

require('everforest').setup({
    background = 'hard',
    transparent_background_level = 0,
})

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        if vim.g.colors_name == "everforest" then
        --     vim.api.nvim_set_hl(0, "Visual", { bg = "#4b545a", })
        --     vim.api.nvim_set_hl(0, 'DiffText', { bg = '#49616a' })

        -- vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })

            local float_hl = vim.api.nvim_get_hl(0, { name = 'NormalFloat', link = false })
            local title_hl = vim.api.nvim_get_hl(0, { name = 'FloatTitle', link = false })
            title_hl.bg = float_hl.bg
            vim.api.nvim_set_hl(0, 'FloatTitle', title_hl)

        end

        -- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
        -- vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })

        -- vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { link = 'DiagnosticWarn' })
        -- vim.api.nvim_set_hl(0, 'DiagnosticSignError', { link = 'DiagnosticError' })
        -- vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { link = 'DiagnosticInfo' })
        -- vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { link = 'DiagnosticHint' })
        --
        -- for _, name in ipairs({ 'LspReferenceText', 'LspReferenceRead', 'LspReferenceWrite' }) do
        --     vim.api.nvim_set_hl(0, name, { link = 'Visual' })
        -- end
    end,
})

vim.cmd('colorscheme everforest')
