
-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '


-- [[ VIM UI ]]
vim.opt.number = true -- Print the line number in front of each line
vim.opt.relativenumber = true --Print relative line numbers
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.smartcase = true
vim.opt.cursorline = true -- Highlight the line where the cursor is on
vim.opt.scrolloff = 5 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.list = true -- Show <tab> and trailing spaces
vim.opt.confirm = true -- confirm before performing actions with unsaved changes
vim.opt.ruler = true -- Always show info along the bottom
vim.opt.list = false -- do not show whitespace characters by default
vim.opt.listchars:append('space:·') -- show spaces as · when list is on
vim.opt.visualbell = true -- screen flash for bell indicator
vim.opt.showmatch = true -- show matching parentheses

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.opt.clipboard = 'unnamedplus'
  end,
})


-- [[ TEXT FORMATTING ]]
vim.opt.autoindent = true -- auto-indent
vim.opt.tabstop = 4 -- tab spacing
vim.opt.softtabstop = 4 -- unify tab behavior
vim.opt.shiftwidth = 4 -- indent/outdent by 4 columns
vim.opt.shiftround = true -- always indent/outdent to nearest tabstop
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.linebreak = true -- don't break words when wrapping
vim.opt.wrap = false -- don't wrap text


-- [[ KEYMAPPINGS ]]
-- See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')
-- Center search results when navigating
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', '*', '*zz')
vim.keymap.set('n', '#', '#zz')
vim.keymap.set('n', 'g*', 'g*zz')
vim.keymap.set('n', 'g#', 'g#zz')
vim.keymap.set('n', '<C-o>', '<C-o>zz')
vim.keymap.set('n', '<C-i>', '<C-i>zz')
vim.keymap.set("n", "<leader><leader>", "<cmd>noh<CR>", {
  desc = "Clear search highlight",
})
-- jk as escape in insert and visual mode
vim.keymap.set({'i', 'v'}, 'jk', '<esc>')


-- [[ AUTOCOMMANDS ]].
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- autocmd for insert mode relative/absolute line numbers
vim.api.nvim_create_autocmd("InsertEnter", { command = [[set norelativenumber]] })
vim.api.nvim_create_autocmd("InsertLeave", { command = [[set relativenumber]] })

