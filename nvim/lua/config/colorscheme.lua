-- [[ Colorscheme ]]

vim.opt.termguicolors = true
vim.opt.background = "dark"
require("gruvbox").setup({ contrast = "" })
vim.cmd([[colorscheme gruvbox]])
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "DiagnosticSignError", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn",  { link = "DiagnosticWarn" })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo",  { link = "DiagnosticInfo" })
vim.api.nvim_set_hl(0, "DiagnosticSignHint",  { link = "DiagnosticHint" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "FloatTitle", { link = "NormalFloat" })
-- Manually put in gruvbox NormalFloat bg color here with no blend
vim.api.nvim_set_hl(0, "TreesitterContext", { bg = '#3c3836', blend = 0 })
vim.opt.winblend = 12
vim.opt.pumblend = 12
vim.opt.colorcolumn = "81"
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#2d2c2b"})

