-- [[ Termdebug Setup ]]

vim.cmd('packadd! termdebug')

vim.g.termdebug_config = {
    command = { 'gdb-multiarch', '-q' },
    sign_decimal = 1,
}

vim.keymap.set('n', '<F5>', function()
    vim.cmd('Continue')
end)

vim.keymap.set('n', '<F8>', function()
    vim.cmd('Stop')
end)

vim.keymap.set('n', '<F10>', function()
    vim.cmd('Over')
end)

vim.keymap.set('n', '<F11>', function()
    vim.cmd('Step')
end)

vim.keymap.set('n', '<F12>', function()
    vim.cmd('Finish')
end)
