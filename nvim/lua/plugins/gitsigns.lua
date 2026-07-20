-- [[ gitsigns setup ]]

require("gitsigns").setup({
    signs = {
        add          = { text = '+' },
        change       = { text = '┃' },
        delete       = { text = '-' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    signs_staged = {
        add          = { text = '+' },
        change       = { text = '┃' },
        delete       = { text = '-' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
    on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal({ ']c', bang = true })
            else
                gitsigns.nav_hunk('next')
            end
        end)

        map('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal({ '[c', bang = true })
            else
                gitsigns.nav_hunk('prev')
            end
        end)

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)
        map('n', '<leader>hp', gitsigns.preview_hunk)
        map('n', '<leader>hd', gitsigns.diffthis)
        map('n', '<leader>hb', gitsigns.blame)
        map('n', '<leader>hl', gitsigns.toggle_current_line_blame)

        vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
            link = nil,
            fg = vim.api.nvim_get_hl(0, { name = "NonText" }).fg,
            italic = true,
        })

        vim.keymap.set('n', '<leader>hq', function()
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                local buf = vim.api.nvim_win_get_buf(win)
                local name = vim.api.nvim_buf_get_name(buf)

                if name:match('^gitsigns://') then
                    vim.api.nvim_win_close(win, true)
                end
            end
        end, {
            buffer = bufnr,
            desc = 'Close gitsigns diff',
        })
    end
})
