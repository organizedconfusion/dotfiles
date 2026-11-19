-- [[ csvview setup ]]

require('csvview').setup({
    keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { 'if', mode = { 'o', 'x' }, desc = 'Select inner CSV field.' },
        textobject_field_outer = { 'af', mode = { 'o', 'x' }, desc = 'Select outer CSV field.' },

        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { '<Tab>', mode = { 'n', 'v' }, desc = 'Jump to the next CSV field.' },
        jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' }, desc = 'Jump to the previous CSV field.' },
        jump_next_row = { '<Enter>', mode = { 'n', 'v' }, desc = 'Jump to the next CSV row.' },
        jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' }, desc = 'Jump to the previous CSV row.' },
    },
})

-- Turn on the CSV view automatically for csv and tsv files
vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('config_csvview', { clear = true }),
    pattern = { 'csv', 'tsv' },
    desc = 'Enable CSV View automatically on .csv and .tsv files',
    callback = function()
        require('csvview').enable()
    end,
})
