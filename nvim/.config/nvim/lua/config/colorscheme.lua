-- [[ Colorscheme ]]

vim.opt.termguicolors = true
vim.opt.background = 'dark'

-- The 'auto' flavour follows 'background'
require('catppuccin').setup {
    flavour = 'auto',
}

vim.cmd.colorscheme('catppuccin')
