-- [[ Non-plugin specific keymaps ]]
-- See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

local map = vim.keymap.set

--- Simple single command convenience function
local function cmd(cmd_string)
    return function()
        vim.cmd(cmd_string)
    end
end

-- [[ Simple Keymaps ]]
map({ 'i' }, 'jk', '<ESC>', { desc = "Map jk key combo to <ESC> in insert mode." })

map('n', '<leader><leader>', cmd('noh'), { desc = "Clear search highlighting." })

map('n', '<leader>w', cmd('write'), { desc = "Write buffer." })

map({ 't', 'i' }, '<C-h>', '<C-\\><C-n><C-w>h', { desc = "Select window left, terminal and insert modes." })
map({ 't', 'i'}, '<C-j>', '<C-\\><C-n><C-w>j', { desc = "Select window down, terminal and insert modes." })
map({ 't', 'i' }, '<C-k>', '<C-\\><C-n><C-w>k', { desc = "Select window up, terminal and insert modes." })
map({ 't', 'i' }, '<C-l>', '<C-\\><C-n><C-w>l', { desc = "Select window right, terminal and insert modes." })
map({ 'n' }, '<C-h>', '<C-w>h', { desc = "Select window left." })
map({ 'n' }, '<C-j>', '<C-w>j', { desc = "Select window down." })
map({ 'n' }, '<C-k>', '<C-w>k', { desc = "Select window up." })
map({ 'n' }, '<C-l>', '<C-w>l', { desc = "Select window right." })
map({ 'n' }, '<leader>.', cmd('winc 10>'), { silent = true, desc = "Widen window 10 columns." })
map({ 'n' }, '<leader>,', cmd('winc 10<'), { silent = true, desc = "Shrink window 10 columns." })

-- [[ Function Keymaps ]]
map('n', 'gl', function()
    vim.diagnostic.open_float()
end, { desc = "Open the diagnostic float on the at the cursor." })

map('n', 'gL', function()
    vim.diagnostic.setloclist({ open = true })
end, { desc = "Open the diagnostic list for the buffer." })

map('n', ']d', function()
    vim.diagnostic.jump({ count = 1, wrap = true })
end, { desc = "Jump to the next diagnostic in the buffer and open the float." })

map('n', '[d', function()
    vim.diagnostic.jump({ count = -1, wrap = true })
end, { desc = "Jump to the previous diagnostic in the buffer and open the float." })

map('n', '<leader>m', function()
    vim.cmd('write')
    vim.cmd('make')
    vim.cmd('cwindow')
end, { desc = "Call make and open the quickfix window if there are errors." })

map('n', '<leader>dl', function()
    vim.cmd('Diffget LOCAL')
end, {desc = 'Use custom Diffget command on local buffer'})

map('n', '<leader>dr', function()
    vim.cmd('Diffget REMOTE')
end, {desc = 'Use custom Diffget command on remote buffer'})

map('n', '<leader>nq', function()
    local ok, err = pcall(vim.cmd, 'cnewer')
    if not ok then
        vim.notify(err, vim.log.levels.INFO)
    end
end, { desc = 'Go to a newer quickfix list.' })

map('n', '<leader>oq', function()
    local ok, err = pcall(vim.cmd, 'colder')
    if not ok then
        vim.notify(err, vim.log.levels.INFO)
    end
end, { desc = 'Go to an older quickfix list.' })

map("n", "<leader>vo", function()
    -- snacks errors if setup runs twice, so keep it cached; restart nvim for snacks.lua changes
    for name in pairs(package.loaded) do
        if (name:match("^config%.") or name:match("^plugins%."))
            and name ~= "plugins.snacks" then
            package.loaded[name] = nil
        end
    end
    vim.cmd.source(vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "Reload config" })

map("n", "<leader>vi", function()
    vim.cmd.edit(vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "Edit init.lua" })

map('v', '<Leader>=', 'c<C-r>=eval(trim(@"))<CR>')

map('n', '<leader>yl', function()
    local ref = vim.fn.expand('%:.') .. ':' .. vim.fn.line('.')
    vim.fn.setreg('+', ref)
end, { desc = 'Copy file:line' })

map('x', '<leader>yl', function()
    local a, b = vim.fn.line('v'), vim.fn.line('.')
    if a > b then a, b = b, a end
    local ref = vim.fn.expand('%:.') .. ':' .. a .. (a ~= b and ('-' .. b) or '')
    vim.fn.setreg('+', ref)
    vim.api.nvim_feedkeys(vim.keycode('<Esc>'), 'n', false)
end, { desc = 'Copy file:line range' })

map('n', '<C-q>', function()
    local mc_ns = vim.api.nvim_create_namespace('nvim.multicursor')
    vim.api.nvim_buf_clear_namespace(0, mc_ns, 0, -1)
end, { desc = "Clear multicursors in the current buffer." })

map('n', 'Y', function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd('normal! ^y$')
    vim.api.nvim_win_set_cursor(0, pos)
end, { desc = "Yank line without newline." })
