-- Clean / zen mode: hides UI chrome globally and restores the exact prior state on exit.

local M = {}

local active = false

local saved = {
    inlay_hints = nil,
    line_blame = nil,
    context = nil,
    diagnostics = nil,
    laststatus = nil,
    cmdheight = nil,
    wins = {},
}

local clean_win_opts = { number = false, relativenumber = false, signcolumn = 'no' }

local function set_win_opt(win, name, value)
    vim.api.nvim_set_option_value(name, value, { scope = 'local', win = win })
end

local function clean_window(win)
    if not vim.api.nvim_win_is_valid(win) or saved.wins[win] then
        return
    end
    if vim.api.nvim_win_get_config(win).relative ~= '' then
        return
    end
    local state = {}
    for name, value in pairs(clean_win_opts) do
        state[name] = vim.api.nvim_get_option_value(name, { scope = 'local', win = win })
        set_win_opt(win, name, value)
    end
    saved.wins[win] = state
end

vim.api.nvim_create_autocmd({ 'WinNew', 'BufWinEnter' }, {
    callback = function()
        if active then
            vim.schedule(function()
                clean_window(vim.api.nvim_get_current_win())
            end)
        end
    end,
})

function M.is_active()
    return active
end

local function enter()
    if vim.lsp.inlay_hint and vim.lsp.inlay_hint.is_enabled then
        saved.inlay_hints = vim.lsp.inlay_hint.is_enabled()
    end

    local ok, gs_config = pcall(require, 'gitsigns.config')
    saved.line_blame = ok and gs_config.config.current_line_blame or nil
    local ok_ctx, ctx = pcall(require, 'treesitter-context')
    saved.context = ok_ctx and ctx.enabled() or nil
    saved.diagnostics = vim.diagnostic.is_enabled()
    saved.laststatus = vim.o.laststatus
    saved.cmdheight = vim.o.cmdheight

    active = true

    vim.diagnostic.enable(false)

    saved.wins = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        clean_window(win)
    end

    vim.o.laststatus = 0
    vim.o.cmdheight = 0

    if vim.lsp.inlay_hint then
        vim.lsp.inlay_hint.enable(false)
    end

    pcall(function()
        require('treesitter-context').disable()
    end)

    vim.g.miniindentscope_disable = true

    vim.g.minitrailspace_disable = true
    if _G.MiniTrailspace then
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            vim.api.nvim_win_call(win, MiniTrailspace.unhighlight)
        end
    end

    pcall(function()
        require('gitsigns').toggle_current_line_blame(false)
    end)
end

local function exit()
    active = false

    vim.diagnostic.enable(saved.diagnostics ~= false)

    for win, state in pairs(saved.wins) do
        if vim.api.nvim_win_is_valid(win) then
            for name, value in pairs(state) do
                set_win_opt(win, name, value)
            end
        end
    end
    saved.wins = {}

    vim.o.laststatus = saved.laststatus or 2
    vim.o.cmdheight = saved.cmdheight or 1

    if vim.lsp.inlay_hint and saved.inlay_hints ~= nil then
        vim.lsp.inlay_hint.enable(saved.inlay_hints)
    end

    if saved.context then
        pcall(function()
            require('treesitter-context').enable()
        end)
    end

    vim.g.miniindentscope_disable = false

    vim.g.minitrailspace_disable = false
    if _G.MiniTrailspace then
        MiniTrailspace.highlight()
    end

    pcall(function()
        if saved.line_blame ~= nil then
            require('gitsigns').toggle_current_line_blame(saved.line_blame)
        end
    end)
end

function M.toggle()
    if active then
        exit()
    else
        enter()
    end
end

vim.keymap.set('n', '<leader>tz', M.toggle, { desc = 'Toggle clean mode' })

return M
