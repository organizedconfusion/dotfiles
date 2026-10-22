-- [[ snacks setup ]]
-- Picker, dashboard, explorer and input are left disabled: mini.* covers those.

require("snacks").setup({
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    notifier = { enabled = true },
    bufdelete = { enabled = true },
    scroll = { enabled = false },
})

local map = vim.keymap.set

map('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete buffer' })
map('n', '<leader>nh', function() Snacks.notifier.show_history() end, { desc = 'Notification history' })
map('n', '<leader>nd', function() Snacks.notifier.hide() end, { desc = 'Dismiss notifications' })
