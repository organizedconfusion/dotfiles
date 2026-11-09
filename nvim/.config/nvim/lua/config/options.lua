-- [[ Neovim Options ]]

local clean_mode = require('config.clean_mode')
local augroup = vim.api.nvim_create_augroup('config_options', { clear = true })

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
    group = augroup,
    callback = function()
        if clean_mode.is_active() or vim.bo.buftype ~= "" or vim.wo.diff then
            return
        end

        vim.opt.relativenumber = false
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    group = augroup,
    callback = function()
        if clean_mode.is_active() or vim.bo.buftype ~= "" or vim.wo.diff then
            return
        end

        vim.opt.relativenumber = true
    end,
})

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
  group = augroup,
  callback = function()
    vim.opt.clipboard = 'unnamedplus'
  end,
})

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup,
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.hl_op()
  end,
})

local function any_diff_saved()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.w[win].diff_saved then
            return true
        end
    end
    return false
end

local function diff_enter(win)
    if vim.w[win].diff_saved then
        return
    end
    local buf = vim.api.nvim_win_get_buf(win)
    if not any_diff_saved() then
        local ok, ctx = pcall(require, 'treesitter-context')
        vim.g.diff_context_enabled = ok and ctx.enabled() or false
        if ok then
            ctx.disable()
        end
    end
    vim.w[win].diff_saved = {
        signcolumn = vim.wo[win].signcolumn,
        number = vim.wo[win].number,
        relativenumber = vim.wo[win].relativenumber,
        bufnr = buf,
        diagnostics = vim.diagnostic.is_enabled({ bufnr = buf }),
    }
    vim.wo[win].signcolumn = 'no'
    vim.wo[win].number = true
    vim.wo[win].relativenumber = false
    vim.diagnostic.enable(false, { bufnr = buf })
end

local function diff_leave(win)
    local saved = vim.w[win].diff_saved
    if not saved then
        return
    end
    vim.w[win].diff_saved = nil
    vim.wo[win].signcolumn = saved.signcolumn
    vim.wo[win].number = saved.number
    vim.wo[win].relativenumber = saved.relativenumber
    if vim.api.nvim_buf_is_valid(saved.bufnr) then
        vim.diagnostic.enable(saved.diagnostics, { bufnr = saved.bufnr })
    end
    if not any_diff_saved() and vim.g.diff_context_enabled then
        pcall(function()
            require('treesitter-context').enable()
        end)
    end
end

local function sync_diff_windows()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative == '' then
            if vim.wo[win].diff then
                diff_enter(win)
            else
                diff_leave(win)
            end
        end
    end
end

vim.api.nvim_create_autocmd("OptionSet", {
    group = augroup,
    pattern = "diff",
    callback = sync_diff_windows,
})

vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    callback = sync_diff_windows,
})

vim.api.nvim_create_autocmd("WinClosed", {
    group = augroup,
    callback = function()
        vim.schedule(sync_diff_windows)
    end,
})

-- Keep terminals out of the buffer list so deleting a buffer never falls back to them
vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup,
    callback = function() vim.bo.buflisted = false end,
})

-- Enter insert mode when opening or returning to a terminal window.
-- nvim-dap renames its terminals to "[dap-terminal] ...", and creates them mid-launch,
-- so those only get insert mode once the session is initialized.
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
    group = augroup,
    pattern = { "term://*", "\\[dap-terminal\\]*" },
    callback = function()
        local dap = package.loaded['dap']
        local session = dap and dap.session()
        if session and not session.initialized then return end
        vim.cmd("startinsert")
    end,
})

vim.opt.grepprg = 'rg --vimgrep --smart-case'
vim.opt.grepformat = '%f:%l:%c:%m'

-- open the quickfix list after :grep
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    group = augroup,
    pattern = '[^l]*',
    command = 'cwindow',
})

-- Native tabpage labels: icon + file name only (no path). Hidden until a second tab exists.
function _G.tabline_labels()
    local parts = {}
    local current = vim.fn.tabpagenr()
    for i = 1, vim.fn.tabpagenr('$') do
        local buf = vim.fn.tabpagebuflist(i)[vim.fn.tabpagewinnr(i)]
        local path = vim.fn.bufname(buf)
        local name = vim.fn.fnamemodify(path, ':t')
        local icon = ''
        if name == '' then
            name = '[No Name]'
        elseif _G.MiniIcons then
            icon = _G.MiniIcons.get('file', name) .. ' '
        end
        local modified = vim.fn.getbufvar(buf, '&modified') == 1 and ' +' or ''
        local hl = i == current and '%#TabLineSel#' or '%#TabLine#'
        parts[#parts + 1] = string.format('%%%dT%s %d %s%s%s ', i, hl, i, icon, name, modified)
    end
    return table.concat(parts) .. '%#TabLineFill#%T'
end
vim.o.tabline = '%!v:lua.tabline_labels()'
vim.o.showtabline = 1
