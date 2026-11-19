-- [[ Colorscheme ]]

vim.opt.termguicolors = true
vim.opt.background = 'dark'

-- The 'auto' flavour follows 'background'
require('catppuccin').setup {
    flavour = 'auto',
    lsp_styles = {
        underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
            ok = { 'undercurl' },
        },
    },
    auto_integrations = true,
}

vim.cmd.colorscheme('catppuccin')
