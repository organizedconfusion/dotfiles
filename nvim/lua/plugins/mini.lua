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

local gen_loader = require('mini.snippets').gen_loader
require('mini.snippets').setup({
    snippets = {
        -- Load custom file with global snippets first (adjust for Windows)
        gen_loader.from_file('~/.config/nvim/snippets/global.json'),

        -- Load snippets based on current language by reading files from
        -- "snippets/" subdirectories from 'runtimepath' directories.
        gen_loader.from_lang({'c'}),
    },
    mappings = {
        stop = '<ESC>',
    }
})

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

-- Tab mapping
local snippets = require('mini.snippets')
local match_strict = function(snips)
    -- Do not match with whitespace to cursor's left
    return snippets.default_match(snips, { pattern_fuzzy = '%S+' })
end
snippets.setup({
    -- ... Set up snippets ...
    mappings = { expand = '', jump_next = '', jump_prev = '' },
    expand   = { match = match_strict },
})
local expand_or_jump = function()
    local can_expand = #MiniSnippets.expand({ insert = false }) > 0
    if can_expand then
        vim.schedule(MiniSnippets.expand); return ''
    end
    local is_active = MiniSnippets.session.get() ~= nil
    if is_active then
        MiniSnippets.session.jump('next'); return ''
    end
    return '\t'
end
local jump_prev = function() MiniSnippets.session.jump('prev') end
vim.keymap.set('i', '<Tab>', expand_or_jump, { expr = true })
vim.keymap.set('i', '<S-Tab>', jump_prev)

-- Allow snippets to show up in mini.complete
MiniSnippets.start_lsp_server()

require('mini.completion').setup({
    delay = { signature = 10000000 }, -- Effectively, disable signature
    window = {
        info = { border = 'rounded' },
        signature = { border = 'rounded' },
    }
})

-- Keymaps
vim.keymap.set('n', '<leader>f', ':Pick files<CR>')
vim.keymap.set('n', '<leader>b', ':Pick buffers<CR>')
vim.keymap.set('n', '<leader>hh', ':Pick help<CR>')
vim.keymap.set('n', '<leader>g', ':Pick grep_live<CR>')
vim.keymap.set('n', '<leader>e', ':lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>')
vim.keymap.set('n', '<leader>E', ':lua MiniFiles.open()<CR>')
