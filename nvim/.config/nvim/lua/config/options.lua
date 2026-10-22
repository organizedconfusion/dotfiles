-- [[ Neovim Options ]]

local clean_mode = require('config.clean_mode')

local my = {
    signcolumn = 'yes:1',
}

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
vim.opt.signcolumn = my.signcolumn
vim.opt.numberwidth = 4
vim.opt.updatetime = 250
vim.opt.winborder = 'rounded'
vim.opt.timeout = true
vim.opt.timeoutlen = 300
-- vim.opt.colorcolumn = '110'
vim.opt.mouse = 'a'
vim.opt.guicursor='n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-blinkon500-blinkoff500-TermCursor'
vim.opt.laststatus = 2
vim.opt.splitright = true
vim.opt.splitbelow = true

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
  local ok, err = pcall(fn)
  vim.o.diffopt = old
  if not ok then
    vim.notify(tostring(err), vim.log.levels.ERROR)
  end
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

vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
       if clean_mode.is_active() or vim.bo.buftype ~= "" then
            return
        end

        vim.opt.relativenumber = false
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
        if clean_mode.is_active() or vim.bo.buftype ~= "" then
            return
        end

        vim.opt.relativenumber = true
    end,
})

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

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.wo.diff then
            vim.opt.number = true
            vim.opt.relativenumber = false
            vim.opt.signcolumn = 'no'

            pcall(function()
                require("treesitter-context").disable()
            end)
        end
    end,
})

-- Keep terminals out of the buffer list so deleting a buffer never falls back to them
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function() vim.bo.buflisted = false end,
})
