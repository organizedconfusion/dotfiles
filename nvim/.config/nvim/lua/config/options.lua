-- [[ Neovim Options ]]

local clean_mode = require('config.clean_mode')
local augroup = vim.api.nvim_create_augroup('config_options', { clear = true })

local my = {
    signcolumn = 'yes:1',
}

-- [[ UI ]]

-- Line numbers: relative, with the absolute number on the cursor line
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.signcolumn = my.signcolumn

-- Search: case-insensitive unless the pattern contains capitals
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Cursor, scrolling and bracket matching
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.ruler = true
vim.opt.showmatch = true
vim.opt.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-blinkon500-blinkoff500-TermCursor'

-- Whitespace rendering: off by default, spaces are shown as dots when enabled
vim.opt.list = false
vim.opt.listchars:append('space:·')

-- Windows, borders and statusline
vim.opt.winborder = 'rounded'
vim.opt.winblend = 0
vim.opt.laststatus = 2
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Input and timing
vim.opt.mouse = 'a'
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.updatetime = 250
vim.opt.visualbell = true

-- [[ Formatting ]]

-- Indentation: 4 spaces, rounded to a multiple of shiftwidth
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true

-- Wrapping: no wrap by default; wrapped lines keep their indent and show a marker
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = '↪ '

-- [[ Completion ]]

-- Popup menu behaviour for completion
vim.o.completeopt = 'menuone,noselect,fuzzy,nosort'
vim.o.complete = '.,w,b'
vim.o.pumheight = 20

-- [[ Misc ]]

-- Blank out the filler characters in diff windows
vim.opt.fillchars = {
    diff = ' ',
}

-- Treat .h files as C instead of C++
vim.g.c_syntax_for_h = 1

-- Load project-local .nvim.lua files (e.g. project debug configs), restricted by 'secure'
vim.o.exrc = true
vim.o.secure = true

-- [[ Diff commands ]]

-- Run fn with 'linematch' removed from 'diffopt' so diffget/diffput act on whole hunks.
-- The original value is always restored, even if fn errors.
local function with_linematch_disabled(fn)
    local old = vim.o.diffopt
    vim.o.diffopt = old:gsub(',?linematch:%d+', ''):gsub(',?linematch', '')
    local ok, err = pcall(fn)
    vim.o.diffopt = old
    if not ok then
        vim.notify(tostring(err), vim.log.levels.ERROR)
    end
end

-- :Diffget {buffer} / :Diffput {buffer}: diffget/diffput without linematch
vim.api.nvim_create_user_command('Diffget', function(opts)
    with_linematch_disabled(function()
        vim.cmd('diffget ' .. opts.args)
    end)
end, { nargs = 1, complete = 'buffer' })

vim.api.nvim_create_user_command('Diffput', function(opts)
    with_linematch_disabled(function()
        vim.cmd('diffput ' .. opts.args)
    end)
end, { nargs = 1, complete = 'buffer' })

-- [[ Autocmds ]]

-- Show absolute line numbers in insert mode and relative ones otherwise.
-- Skipped in clean mode, special buffers and diff windows.
vim.api.nvim_create_autocmd('InsertEnter', {
    group = augroup,
    callback = function()
        if clean_mode.is_active() or vim.bo.buftype ~= '' or vim.wo.diff then
            return
        end

        vim.opt.relativenumber = false
    end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
    group = augroup,
    callback = function()
        if clean_mode.is_active() or vim.bo.buftype ~= '' or vim.wo.diff then
            return
        end

        vim.opt.relativenumber = true
    end,
})

-- Sync clipboard between OS and Neovim. Scheduled after `UIEnter` because it can
-- increase startup time. Remove this to keep the OS clipboard independent.
-- See `:help 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
    group = augroup,
    callback = function()
        vim.opt.clipboard = 'unnamedplus'
    end,
})

-- Highlight yanked text briefly. Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    group = augroup,
    desc = 'Highlight when yanking (copying) text',
    callback = function()
        vim.hl.hl_op()
    end,
})

-- [[ Diff window decoration ]]
-- Diff windows get a plain gutter, no diagnostics and no treesitter context.
-- The previous state is saved per window (w:diff_saved) and restored when diff mode ends.

local function any_diff_saved()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.w[win].diff_saved then
            return true
        end
    end
    return false
end

-- Strip a window's gutter and diagnostics for diffing, remembering what to restore.
-- Treesitter context is disabled globally while any window is in diff mode.
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

-- Restore a window's saved gutter and diagnostics once it leaves diff mode,
-- and re-enable treesitter context after the last diff window is gone
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

-- Apply or undo diff decoration for every normal window to match its 'diff' state
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

vim.api.nvim_create_autocmd('OptionSet', {
    group = augroup,
    pattern = 'diff',
    callback = sync_diff_windows,
})

vim.api.nvim_create_autocmd('VimEnter', {
    group = augroup,
    callback = sync_diff_windows,
})

vim.api.nvim_create_autocmd('WinClosed', {
    group = augroup,
    callback = function()
        vim.schedule(sync_diff_windows)
    end,
})

-- [[ Terminal ]]

-- Keep terminals out of the buffer list so deleting a buffer never falls back to them
vim.api.nvim_create_autocmd('TermOpen', {
    group = augroup,
    callback = function() vim.bo.buflisted = false end,
})

-- Enter insert mode when opening or returning to a terminal window.
-- nvim-dap renames its terminals to '[dap-terminal] ...', and creates them mid-launch,
-- so those only get insert mode once the session is initialized.
vim.api.nvim_create_autocmd({ 'TermOpen', 'BufEnter' }, {
    group = augroup,
    pattern = { 'term://*', '\\[dap-terminal\\]*' },
    callback = function()
        local dap = package.loaded['dap']
        local session = dap and dap.session()
        if session and not session.initialized then return end
        vim.cmd('startinsert')
    end,
})

-- [[ Grep and quickfix ]]

-- Use ripgrep for :grep
vim.opt.grepprg = 'rg --vimgrep --smart-case'
vim.opt.grepformat = '%f:%l:%c:%m'

-- Open the quickfix list after :grep
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    group = augroup,
    pattern = '[^l]*',
    command = 'cwindow',
})

-- [[ Tabline ]]

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
