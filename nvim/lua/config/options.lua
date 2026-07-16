-- [[ Neovim Options ]]

-- UI 
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.ruler = true
vim.opt.list = false
vim.opt.listchars:append('space:·')
vim.opt.visualbell = true
vim.opt.showmatch = true
--vim.opt.signcolumn = 'yes:2'
vim.opt.signcolumn = 'number'
vim.opt.winborder = 'rounded'
vim.opt.timeout = true
vim.opt.timeoutlen = 300
-- vim.opt.colorcolumn = '110'
vim.opt.mouse = 'a'
vim.opt.mousemoveevent = true

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

vim.o.completeopt = 'menuone,noselect,fuzzy,nosort'
vim.o.complete = '.,w,b'
vim.o.pumheight = 20

vim.opt.fillchars = {
    diff = " ",
}

vim.g.c_syntax_for_h = 1

vim.o.exrc = true
vim.o.secure = true

local function with_linematch_disabled(fn)
  local old = vim.o.diffopt
  -- remove linematch completely
  vim.o.diffopt = old:gsub(",?linematch:%d+", ""):gsub(",?linematch", "")
  pcall(fn)
  vim.o.diffopt = old
end

vim.api.nvim_create_user_command("Diffget", function(opts)
  with_linematch_disabled(function()
    vim.cmd("diffget " .. opts.args)
  end)
end, { nargs = 1, complete = "buffer" })

vim.api.nvim_create_user_command("Diffput", function(opts)
  with_linematch_disabled(function()
    vim.cmd("diffput " .. opts.args)
  end)
end, { nargs = 1, complete = "buffer" })

vim.api.nvim_create_autocmd("InsertEnter", { command = 'set norelativenumber' })
vim.api.nvim_create_autocmd("InsertLeave", { command = 'set relativenumber' })

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.opt.clipboard = 'unnamedplus'
  end,
})

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.hl_op()
  end,
})
