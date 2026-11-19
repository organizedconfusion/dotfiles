local dap = require('dap')

-- [[ UI ]]
-- dap-view: a bottom panel with scopes, breakpoints, watches and a control bar.
-- It opens automatically when a program terminal opens.
require('dap-view').setup({
    auto_toggle = 'open_term',
    winbar = {
        default_section = 'scopes',
        controls = {
            enabled = true,
            position = 'left',
            buttons = {
                'play',
                'step_into',
                'step_over',
                'step_out',
                'step_back',
                'run_last',
                'terminate',
                'disconnect',
            },
        },
    },
    windows = {
        size = 0.333,
        position = 'bottom',
    },
})

-- [[ C/C++ (gdb) ]]

-- Prefer gdb-multiarch (for cross-targets), falling back to plain gdb
local gdb = vim.fn.executable('gdb-multiarch') == 1 and 'gdb-multiarch'
    or vim.fn.executable('gdb') == 1 and 'gdb'
    or nil

-- gdb speaks DAP natively with --interpreter=dap
if gdb then
    dap.adapters.gdb = {
        type = 'executable',
        command = gdb,
        args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
    }
end

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

-- [[ Python (debugpy) ]]

-- Use the active venv's python if there is one, otherwise whichever python exists
local function python_path()
    local venv = os.getenv('VIRTUAL_ENV')
    if venv then
        return venv .. '/bin/python'
    end
    return vim.fn.executable('python3') == 1 and 'python3' or 'python'
end

-- debugpy must be installed in the python this resolves to (IMPORTANT: your venv).
-- The adapter is only started once an import check confirms debugpy is available.
dap.adapters.python = function(callback)
    local python = python_path()
    vim.system({ python, '-c', 'import debugpy' }, {}, vim.schedule_wrap(function(res)
        if res.code ~= 0 then
            vim.notify('debugpy not installed for ' .. python, vim.log.levels.ERROR)
            return
        end
        callback({
            type = 'executable',
            command = python,
            args = { '-m', 'debugpy.adapter' },
        })
    end))
end

-- Prompt for a whitespace-separated argument list
local function prompt_args()
    return vim.split(vim.fn.input('Args: '), '%s+', { trimempty = true })
end

dap.configurations.python = {
    {
        name = 'Launch file',
        type = 'python',
        request = 'launch',
        program = '${file}',
        console = 'integratedTerminal',
        pythonPath = python_path,
    },
    {
        name = 'Launch file with args',
        type = 'python',
        request = 'launch',
        program = '${file}',
        args = prompt_args,
        console = 'integratedTerminal',
        pythonPath = python_path,
    },
    {
        name = 'Launch module with args',
        type = 'python',
        request = 'launch',
        module = function() return vim.fn.input('Module: ') end,
        args = prompt_args,
        console = 'integratedTerminal',
        pythonPath = python_path,
    },
}

-- [[ Keymaps ]]

-- Execution control
vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = 'Debug: continue or start.' })
vim.keymap.set('n', '<S-F5>', function() require('dap').terminate() end, { desc = 'Debug: terminate the session.' })
vim.keymap.set('n', '<F8>', function() require('dap').pause() end, { desc = 'Debug: pause.' })
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end, { desc = 'Debug: step over.' })
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end, { desc = 'Debug: step into.' })
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end, { desc = 'Debug: step out.' })

-- Breakpoints and the dap-view panel
vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end,
    { desc = 'Debug: toggle breakpoint.' })
vim.keymap.set('n', '<Leader>dv', function() require('dap-view').toggle() end,
    { desc = 'Debug: toggle the dap-view panel.' })
vim.keymap.set('n', '<Leader>dt', function() require('dap-view').virtual_text_toggle() end,
    { desc = 'Debug: toggle inline virtual text.' })
vim.keymap.set({ 'n', 'x' }, '<Leader>dw', function() require('dap-view').add_expr(nil, true) end,
    { desc = 'Debug: add the expression or selection to the watches.' })

-- K shows the debugger value while debugging, LSP hover when a server is attached,
-- and falls back to the builtin K otherwise
vim.keymap.set({ 'n', 'x' }, 'K', function()
    if dap.session() then
        require('dap-view').hover()
    elseif #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
        vim.lsp.buf.hover()
    else
        vim.cmd.normal({ 'K', bang = true })
    end
end, { desc = 'Hover (dap when debugging)' })
