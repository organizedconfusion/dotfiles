require('illuminate').configure({
    under_cursor = false,
    filetypes_denylist = {
        'dirbuf',
        'dirvish',
        'fugitive',
        'help'
    }
})
