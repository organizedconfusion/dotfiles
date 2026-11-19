-- [[ Mini setup ]]
-- Configuration for all mini.nvim modules

local augroup = vim.api.nvim_create_augroup('config_mini', { clear = true })

-- [[ Modules ]]

-- File explorer
require('mini.files').setup()

-- Icons; tweak_lsp_kind enables icons in mini.completion
require('mini.icons').setup()
MiniIcons.tweak_lsp_kind()

-- Fuzzy picker: wide window, <C-q> chooses all marked items
require('mini.pick').setup({
    window = {
        config = {
            width = 120,
        },
    },
    mappings = {
        choose_marked = '<C-q>',
    },
})

-- Surround actions (sa, sd, sr, ...)
require('mini.surround').setup()

-- Highlight trailing whitespace
require('mini.trailspace').setup()

-- Session management: sessions are written on exit but never read automatically
require('mini.sessions').setup({
    autoread = false,
    autowrite = true,
    directory = '',
    file = 'Session.vim',
})

-- Input, start screen, notifications and extra pickers/textobjects
require('mini.input').setup({})
require('mini.starter').setup()
require('mini.notify').setup({
    window = {
        winblend = 0,
    },
})
require('mini.extra').setup({})

-- [[ Snippets ]]
-- <C-j> expands a snippet; <Tab> / <S-Tab> jump between tabstops (mapped below)
local snippets = require('mini.snippets')

local gen_loader = require('mini.snippets').gen_loader
snippets.setup({
    mappings = { expand = '<C-j>', jump_next = '', jump_prev = '' },
    snippets = {
        -- Load custom file with global snippets first (adjust for Windows)
        gen_loader.from_file('~/.config/nvim/snippets/global.json'),

        -- Load snippets based on current language by reading files from
        -- 'snippets/' subdirectories from 'runtimepath' directories.
        gen_loader.from_lang(),
    },
})

-- <Tab> jumps to the next tabstop while a snippet session is active, else inserts a tab
local expand_or_jump = function()
    local is_active = MiniSnippets.session.get() ~= nil
    if is_active then
        MiniSnippets.session.jump('next'); return ''
    end
    return '\t'
end

local jump_prev = function() MiniSnippets.session.jump('prev') end

vim.keymap.set('i', '<Tab>', expand_or_jump, { expr = true, desc = 'Jump to the next snippet tabstop, or insert a tab.' })
vim.keymap.set('i', '<S-Tab>', jump_prev, { desc = 'Jump to the previous snippet tabstop.' })

-- Stop the snippet session when returning to normal mode
local make_stop = function()
    local au_opts = { pattern = '*:n', once = true }
    au_opts.callback = function()
        while MiniSnippets.session.get() do
            MiniSnippets.session.stop()
        end
    end
    vim.api.nvim_create_autocmd('ModeChanged', au_opts)
end

local opts = { group = augroup, pattern = 'MiniSnippetsSessionStart', callback = make_stop }

vim.api.nvim_create_autocmd('User', opts)

-- Expose snippets as completion items through mini.snippets' in-process LSP server (start once)
if not vim.g.mini_snippets_lsp_started then
    MiniSnippets.start_lsp_server()
    vim.g.mini_snippets_lsp_started = true
end

-- [[ Completion ]]
require('mini.completion').setup({
    delay = { signature = 10000000 }, -- Effectively, disable signature
    window = {
        info = { height = 25, width = 80, border = 'rounded' },
        signature = { height = 25, width = 80, border = 'rounded' },
    },
})

-- [[ Keymaps ]]

-- Pickers (<leader>p...)
vim.keymap.set('n', '<leader>pf', MiniPick.builtin.files, { desc = 'Pick from files' })

-- Buffer picker; <C-d> wipes out the highlighted buffer
vim.keymap.set('n', '<leader>pb', function()
    local wipeout_cur = function()
        vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
    end

    local buffer_mappings = { wipeout = { char = '<C-d>', func = wipeout_cur } }

    MiniPick.builtin.buffers(nil, { mappings = buffer_mappings })
end, { desc = 'Pick from buffers' })

vim.keymap.set('n', '<leader>ph', MiniPick.builtin.help, { desc = 'Pick from help' })
vim.keymap.set('n', '<leader>pg', MiniPick.builtin.grep_live, { desc = 'Pick from grep_live' })
vim.keymap.set('n', '<leader>pG', MiniPick.builtin.grep, { desc = 'Pick from grep' })

-- Insert-mode file path completion: pick a file and put its path at the cursor
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

vim.keymap.set('n', '<leader>/', function()
    vim.cmd("Pick buf_lines scope='current'")
end, { desc = 'Fuzzy search buffer' })

-- File explorer: open at the current file if it exists on disk, otherwise at the cwd
vim.keymap.set('n', '<leader>e', function()
    local name = vim.api.nvim_buf_get_name(0)
    MiniFiles.open(vim.uv.fs_stat(name) and name or nil)
end, { desc = 'MiniFiles current file' })

vim.keymap.set('n', '<leader>E', MiniFiles.open, { desc = 'MiniFiles cwd' })

-- Notifications
vim.keymap.set('n', '<leader>nh', function() MiniNotify.show_history() end, { desc = 'Notification history' })
vim.keymap.set('n', '<leader>nd', function() MiniNotify.clear() end, { desc = 'Dismiss notifications' })
