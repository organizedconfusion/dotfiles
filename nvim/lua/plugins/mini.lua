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
require('mini.indentscope').setup({
    draw = {
        delay = 250,
        animation = require('mini.indentscope').gen_animation.none(),
    },
    mappings = {
        -- Textobjects
        object_scope = 'it',
        object_scope_with_border = 'at',

        -- Motions (jump to respective border line; if not present - body line)
        goto_top = '[t',
        goto_bottom = ']t',
    },
    options = {
        try_as_border = true,
        indent_at_cursor = false
    },
})

require('mini.trailspace').setup()

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", {
            link = "NonText",
        })
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
        info = { border = 'rounded' },
        signature = { border = 'rounded' },
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

