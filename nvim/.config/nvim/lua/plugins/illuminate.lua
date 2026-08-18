require('illuminate').configure({
    under_cursor = false,
    delay = 200,
    filetypes_denylist = {
        'dirbuf',
        'dirvish',
        'fugitive',
        'help',
        'minifiles'
    }
})
