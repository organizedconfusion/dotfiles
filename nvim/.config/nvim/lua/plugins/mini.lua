-- [[ Mini setup ]]
-- This file used for all mini plugins

require('mini.files').setup()
require('mini.icons').setup()
MiniIcons.tweak_lsp_kind() -- Enables icons in mini.completion
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

        vim.api.nvim_set_hl(0, 'MiniFilesTitle', { fg = mini_title.fg, bg = "NONE", bold = false })
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

vim.keymap.set('n', '<leader>pf', MiniPick.builtin.files, { desc = 'Pick from files' })
vim.keymap.set('n', '<leader>pb', MiniPick.builtin.buffers, { desc = 'Pick from buffers' })
vim.keymap.set('n', '<leader>ph', MiniPick.builtin.help, { desc = 'Pick from help' })
vim.keymap.set('n', '<leader>pg', MiniPick.builtin.grep_live, { desc = 'Pick from grep_live' })
vim.keymap.set('i', '<C-x><C-f>', function()
    MiniPick.builtin.files(nil, {
        source = {
            choose = function(item)
                if item == nil then return end
                vim.schedule(function() vim.api.nvim_put({ item }, 'c', true, true) end)
            end,
        },
    })
end, { desc = 'Pick a file path and insert it' })
vim.keymap.set('n', '<leader>ps', function()
    MiniSessions.select()
end, { desc = 'Pick from sessions' })

vim.keymap.set('n', '<leader>e', function()
    local name = vim.api.nvim_buf_get_name(0)
    MiniFiles.open(vim.uv.fs_stat(name) and name or nil)
end, { desc = 'MiniFiles current file' })

vim.keymap.set('n', '<leader>E', MiniFiles.open, { desc = 'MiniFiles cwd' })
