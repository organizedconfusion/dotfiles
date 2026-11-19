-- [[ Colorscheme ]]

vim.opt.termguicolors = true
vim.opt.background = 'dark'
require('catppuccin').setup {
    flavour = 'auto',
}

vim.cmd.colorscheme('catppuccin')
