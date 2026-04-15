-- [[ lualine setup ]]

local auto_transparent = require('lualine.themes.auto')

auto_transparent.normal.c.bg = 'None'
auto_transparent.insert.c.bg = 'None'
auto_transparent.visual.c.bg = 'None'
auto_transparent.replace.c.bg = 'None'
auto_transparent.command.c.bg = 'None'
auto_transparent.inactive.c.bg = 'None'

require('lualine').setup({
    options = { theme = auto_transparent }
})

vim.api.nvim_set_hl(0, "StatusLine", { bg = nil })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = nil })
