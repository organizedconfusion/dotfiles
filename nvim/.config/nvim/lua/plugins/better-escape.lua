require('better_escape').setup({
    timeout = 150,
    default_mappings = false,
    mappings = {
        v = {
            j = {
                k = function()
                    vim.api.nvim_feedkeys(vim.keycode('k<Esc>'), 'n', false)
                end
            },
        },
        c = {
            j = {
                k = "<C-c>",
            },
        },
        t = {
            j = {
                k = "<C-\\><C-n>",
            },
        },
    },
})
