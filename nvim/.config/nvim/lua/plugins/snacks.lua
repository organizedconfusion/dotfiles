-- [[ snacks setup ]]
-- Picker, dashboard, explorer and input are left disabled: mini.* covers those.

require("snacks").setup({
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    bufdelete = { enabled = true },
    scroll = { enabled = false },
})

local map = vim.keymap.set

map('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete buffer' })

-- [[ Toggles ]]
Snacks.toggle.diagnostics():map('<leader>td')
Snacks.toggle.inlay_hints():map('<leader>th')
Snacks.toggle.treesitter():map('<leader>tt')

Snacks.toggle.new({
    id = 'clean_mode',
    name = 'Clean Mode',
    get = function() return require('config.clean_mode').is_active() end,
    set = function(state)
        local clean_mode = require('config.clean_mode')
        if state ~= clean_mode.is_active() then
            clean_mode.toggle()
        end
    end,
}):map('<leader>tz')

Snacks.toggle.new({
    id = 'treesitter_context',
    name = 'Treesitter Context',
    get = function() return require('treesitter-context').enabled() end,
    set = function(state)
        require('treesitter-context')[state and 'enable' or 'disable']()
    end,
}):map('<leader>tc')

Snacks.toggle.new({
    id = 'line_blame',
    name = 'Line Blame',
    get = function() return require('gitsigns.config').config.current_line_blame end,
    set = function(state) require('gitsigns').toggle_current_line_blame(state) end,
}):map('<leader>tb')

Snacks.toggle.new({
    id = 'trailing_whitespace',
    name = 'Trailing Whitespace Highlight',
    get = function() return not vim.g.minitrailspace_disable end,
    set = function(state)
        vim.g.minitrailspace_disable = not state
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            vim.api.nvim_win_call(win, state and MiniTrailspace.highlight or MiniTrailspace.unhighlight)
        end
    end,
}):map('<leader>tw')
