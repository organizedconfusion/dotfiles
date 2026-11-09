local dap = require("dap")

require("dap-view").setup({
    auto_toggle = "open_term",
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
        -- size = 0.33,
        -- position = "right"
    }
})

dap.adapters.gdb = {
    type = "executable",
    command = "gdb-multiarch",
    args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

-- Generic configs only; project specifics go in a project-local .nvim.lua
dap.configurations.c = {
    {
        name = 'Attach gdbserver',
        type = 'gdb',
        request = 'attach',
        target = function() return vim.fn.input('Target: ', 'localhost:2331') end,
        program = function() return vim.fn.input('ELF: ', vim.fn.getcwd() .. '/', 'file') end,
    },
}

dap.adapters.python = {
    type = "executable",
    command = "python",  -- uses current python (IMPORTANT: your venv)
    args = { "-m", "debugpy.adapter" },
}

local function python_path()
    -- use venv if active
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then
        return venv .. "/bin/python"
    end
    return "python"
end

local function prompt_args()
    return vim.split(vim.fn.input('Args: '), '%s+', { trimempty = true })
end

dap.configurations.python = {
    {
        name = "Launch file",
        type = "python",
        request = "launch",
        program = "${file}",
        console = "integratedTerminal",
        pythonPath = python_path,
    },
    {
        name = "Launch file with args",
        type = "python",
        request = "launch",
        program = "${file}",
        args = prompt_args,
        console = "integratedTerminal",
        pythonPath = python_path,
    },
    {
        name = "Launch module with args",
        type = "python",
        request = "launch",
        module = function() return vim.fn.input('Module: ') end,
        args = prompt_args,
        console = "integratedTerminal",
        pythonPath = python_path,
    },
}


vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<S-F5>', function() require('dap').terminate() end)
vim.keymap.set('n', '<F8>', function() require('dap').pause() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>dv', function() require('dap-view').toggle() end)
vim.keymap.set('n', '<Leader>dt', function() require('dap-view').virtual_text_toggle() end)
vim.keymap.set({ 'n', 'x' }, '<Leader>dw', function() require('dap-view').add_expr(nil, true) end)
vim.keymap.set({ 'n', 'x' }, 'K', function()
    if dap.session() then
        require('dap-view').hover()
    elseif #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
        vim.lsp.buf.hover()
    else
        vim.cmd.normal({ 'K', bang = true })
    end
end, { desc = 'Hover (dap when debugging)' })
