local dap = require("dap")
local dap_view = require("dap-view")

require("dap-view").setup({
    winbar = {
        default_section = "scopes",
        controls = {
            enabled = true,
            position = "left",
            buttons = {
                "play",
                "step_into",
                "step_over",
                "step_out",
                "step_back",
                "run_last",
                "terminate",
                "disconnect",
            },
        }
    },
})

dap.adapters.gdb = {
    type = "executable",
    command = "gdb-multiarch",
    args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<F8>', function() require('dap').pause() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>dv', function() require('dap-view').toggle() end)
vim.keymap.set('n', '<Leader>dt', function() require('dap-view').virtual_text_toggle() end)
vim.keymap.set({ 'n', 'x' }, '<Leader>dw', function() require('dap-view').add_expr(nil, true) end)
vim.keymap.set({ 'n', 'x' }, 'U', dap_view.hover)
