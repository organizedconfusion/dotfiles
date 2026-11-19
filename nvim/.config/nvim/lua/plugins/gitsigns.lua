-- [[ gitsigns setup ]]

-- Render the inline blame text dimmed and italic, in the NonText colour.
-- Reapplied on every colorscheme change since colorschemes reset highlights.
local function set_blame_hl()
    vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', {
        fg = vim.api.nvim_get_hl(0, { name = 'NonText' }).fg,
        italic = true,
    })
end

vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('config_gitsigns', { clear = true }),
    callback = set_blame_hl,
})
set_blame_hl()

-- Sign column glyphs, shared by working-tree and staged changes
local sign_text = {
    add          = { text = '+' },
    change       = { text = '┃' },
    delete       = { text = '-' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
}

require('gitsigns').setup({
    signs = sign_text,
    signs_staged = sign_text,
    on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        -- Buffer-local keymap helper
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation: fall back to the builtin ]c / [c when in a diff window
        map('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal({ ']c', bang = true })
            else
                gitsigns.nav_hunk('next')
            end
        end, { desc = 'Next git hunk (or diff change).' })

        map('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal({ '[c', bang = true })
            else
                gitsigns.nav_hunk('prev')
            end
        end, { desc = 'Previous git hunk (or diff change).' })

        -- Hunk actions (<leader>h...)
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage the hunk under the cursor.' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset the hunk under the cursor.' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview the hunk under the cursor.' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff the buffer against the index.' })
        map('n', '<leader>hb', gitsigns.blame, { desc = 'Open the blame view for the buffer.' })

        -- Close the gitsigns:// diff windows opened by hd / hb in the current tab
        map('n', '<leader>hq', function()
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                local buf = vim.api.nvim_win_get_buf(win)
                local name = vim.api.nvim_buf_get_name(buf)

                if name:match('^gitsigns://') then
                    vim.api.nvim_win_close(win, true)
                end
            end
        end, { desc = 'Close gitsigns diff' })
    end,
})
