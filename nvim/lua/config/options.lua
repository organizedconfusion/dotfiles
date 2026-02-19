-- [[ Neovim Options ]]

-- UI 
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.scrolloff = 6
vim.opt.ruler = true
vim.opt.list = false
vim.opt.listchars:append('space:·')
vim.opt.visualbell = true
vim.opt.showmatch = true
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.colorcolumn = "81"

-- Formatting 
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.linebreak = true
vim.opt.wrap = false
vim.opt.breakindent = true

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.opt.clipboard = 'unnamedplus'
  end,
})
