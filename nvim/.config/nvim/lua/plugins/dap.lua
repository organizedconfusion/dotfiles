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
    windows = {
        size = 0.33,
        position = "right"
    }
})

dap.adapters.gdb = {
    type = "executable",
    command = "gdb-multiarch",
    args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

dap.adapters.python = {
    type = "executable",
    command = "python",  -- uses current python (IMPORTANT: your venv)
    args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Launch file",

        program = "${file}",

        pythonPath = function()
            -- use venv if active
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
                return venv .. "/bin/python"
            end
            return "python"
        end,
    },
}


vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<S-F5>', function() require('dap').terminate() end)
vim.keymap.set('n', '<F8>', function() require('dap').pause() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>dv', function() require('dap-view').toggle() end)
vim.keymap.set('n', '<Leader>dt', function() require('dap-view').virtual_text_toggle() end)
vim.keymap.set({ 'n', 'x' }, '<Leader>dw', function() require('dap-view').add_expr(nil, true) end)
vim.keymap.set({ 'n', 'x' }, 'U', dap_view.hover)
