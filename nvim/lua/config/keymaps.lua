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
map('n', '<leader>wf', cmd('write'), { desc = "Write current buffer." })
map('t', '<ESC>', '<C-\\><C-n>', { desc = "Leave terminal mode with <ESC>." })
map('t', 'jk', '<C-\\><C-n>', { desc = "Leave terminal mode with jk." })
map({ 'i', 'v' }, 'jk', '<ESC>', { desc = "Map jk key combo to <ESC>." })
map('n', '<leader><leader>', cmd('noh'), { desc = "Clear search highlighting." })
map({ 'n' }, 'Y', '^y$', { desc = "Yank line without newline." })
map({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h', { desc = "Select window left, terminal and insert modes." })
map({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j', { desc = "Select window down, terminal and insert modes." })
map({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k', { desc = "Select window up, terminal and insert modes." })
map({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l', { desc = "Select window right, terminal and insert modes." })
map({ 'n' }, '<A-h>', '<C-w>h', { desc = "Select window left." })
map({ 'n' }, '<A-j>', '<C-w>j', { desc = "Select window down." })
map({ 'n' }, '<A-k>', '<C-w>k', { desc = "Select window up." })
map({ 'n' }, '<A-l>', '<C-w>l', { desc = "Select window right." })
map({ 'n' }, '<leader>.', cmd('winc 10>'), { silent = true, desc = "Stretch window right 10 columns." })
map({ 'n' }, '<leader>,', cmd('winc 10<'), { silent = true, desc = "Stretch window left 10 columns." })
--map('n', 'n', 'nzz', { desc = "Center cursor after searching forwards." })
--map('n', 'N', 'Nzz', { desc = "Center cursor after searching forwards." })
--map('n', '*', '*zz', { desc = "Center cursor after searching word under cursor forwards." })
--map('n', '#', '#zz', { desc = "Center cursor after searching word under cursor backwards." })
--map('n', 'g*', 'g*zz', { desc = "Center cursor after searching substring under cursor forwards." })
--map('n', 'g#', 'g#zz', { desc = "Center cursor after searching substring under cursor backwards." })
--map('n', '<C-o>', '<C-o>zz', { desc = "Center cursor after going to previous jump." })
--map('n', '<C-i>', '<C-i>zz', { desc = "Center cursor after going to next jump ." })

-- [[ Function Keymaps ]]
map('n', '<leader>wo', function()
    vim.cmd('write')
    vim.cmd('source')
end, { desc = "Write and source current buffer." })

map('n', '<leader>d', function()
    vim.diagnostic.open_float()
end, { desc = "Open the diagnostic float on the at the cursor." })

map('n', '<leader>D', function()
    vim.diagnostic.setloclist({ open = true })
end, { desc = "Open the diagnostic list for the buffer." })

map('n', ']d', function()
    vim.diagnostic.jump({ count = 1, wrap = true })
end, { desc = "Jump to the next diagnostic in the buffer and open the float." })

map('n', '[d', function()
    vim.diagnostic.jump({ count = -1, wrap = true })
end, { desc = "Jump to the previous diagnostic in the buffer and open the float." })

map('n', '<leader>t', function()
    local today = vim.fn.strftime("%Y-%m-%d")
    vim.api.nvim_put({ today }, "c", true, true)
end, { desc = "Put the current date string as YYYY-MM-DD." })

map('n', '<leader>m', function()
    vim.cmd('write')
    vim.cmd('make')
    vim.cmd('cwindow')
end, { desc = "Call make and open the quickfix window if there are errors." })

map('n', '<leader>tw', function()
    vim.cmd([[%s/\s\+$//ec]])
    vim.cmd('noh')
end, { desc = "Trim trailing whitespace with confirmation" })

map('n', 'gp', '"0p')
map('n', 'gP', '"0P')
