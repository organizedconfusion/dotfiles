-- [[ Mini setup ]]
-- This file used for all mini plugins

require('mini.files').setup()
require('mini.icons').setup()
MiniIcons.tweak_lsp_kind() -- Enables icons in mini.completion
require('mini.pairs').setup()
require('mini.pick').setup({
    window = {
        config = {
            width = 120,
        }
    }
})
require('mini.surround').setup()
require('mini.trailspace').setup()
require('mini.sessions').setup({ autoread = false, autowrite = true })
require('mini.input').setup()
require('mini.starter').setup()

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { link = "NonText", })

        local mini_title = vim.api.nvim_get_hl(0, { name = "MiniFilesTitle" })

        vim.api.nvim_set_hl(0, 'MiniPickPrompt', { fg = mini_title.fg, bg = "NONE", bold = true })
        vim.api.nvim_set_hl(0, 'MiniPickPromptPrefix', { link = 'MiniPickPrompt' })
        vim.api.nvim_set_hl(0, 'MiniPickPromptCaret', { link = 'MiniPickPrompt' })

        vim.api.nvim_set_hl(0, 'MiniFilesTitle', { fg = mini_title.fg, bg = "NONE" , bold = false })
        vim.api.nvim_set_hl(0, 'MiniFilesTitleFocused', { fg = mini_title.fg, bg = "NONE", bold = true })
    end,
})

-- Tab mapping
local snippets = require('mini.snippets')

local gen_loader = require('mini.snippets').gen_loader
snippets.setup({
    mappings = { expand = '<C-j>', jump_next = '', jump_prev = '' },
    snippets = {
        -- Load custom file with global snippets first (adjust for Windows)
        gen_loader.from_file('~/.config/nvim/snippets/global.json'),

        -- Load snippets based on current language by reading files from
        -- "snippets/" subdirectories from 'runtimepath' directories.
        gen_loader.from_lang(),
    },
})

local expand_or_jump = function()
    local is_active = MiniSnippets.session.get() ~= nil
    if is_active then
        MiniSnippets.session.jump('next'); return ''
    end
    return '\t'
end

local jump_prev = function() MiniSnippets.session.jump('prev') end

vim.keymap.set('i', '<Tab>', expand_or_jump, { expr = true })
vim.keymap.set('i', '<S-Tab>', jump_prev)

-- Stop session when leaving insert mode
local make_stop = function()
    local au_opts = { pattern = '*:n', once = true }
    au_opts.callback = function()
        while MiniSnippets.session.get() do
            MiniSnippets.session.stop()
        end
    end
    vim.api.nvim_create_autocmd('ModeChanged', au_opts)
end

local opts = { pattern = 'MiniSnippetsSessionStart', callback = make_stop }

vim.api.nvim_create_autocmd('User', opts)

-- Allow snippets to show up in mini.complete
MiniSnippets.start_lsp_server()

require('mini.completion').setup({
    delay = { signature = 10000000 }, -- Effectively, disable signature
    window = {
        info = { height = 25, width = 80, border = 'rounded' },
        signature = { height = 25, width = 80, border = 'rounded' },
    }
})

-- Keymaps

vim.keymap.set('n', '<leader>f', MiniPick.builtin.files)
vim.keymap.set('n', '<leader>b', MiniPick.builtin.buffers)
vim.keymap.set('n', '<leader>hh', MiniPick.builtin.help)
vim.keymap.set('n', '<leader>g', MiniPick.builtin.grep_live)

vim.keymap.set('n', '<leader>G', function()
    local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h')
    MiniPick.builtin.grep_live({}, { source = { cwd = dir } })
end, { desc = 'Live grep current file directory' })

vim.keymap.set('n', '<leader>e', function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
end, { desc = 'MiniFiles current file' })

vim.keymap.set('n', '<leader>E', function()
    MiniFiles.open()
end, { desc = 'MiniFiles cwd' })

vim.keymap.set('n', '<leader>s', function()
    MiniSessions.select()
end, { desc = 'Pick from sessions' })
