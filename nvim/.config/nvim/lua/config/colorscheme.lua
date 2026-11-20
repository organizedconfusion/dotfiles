-- [[ Colorscheme ]]

vim.opt.termguicolors = true
vim.opt.background = 'dark'

-- The 'auto' flavour follows 'background'
require('catppuccin').setup {
    flavour = 'auto',
    lsp_styles = {
        underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
            ok = { 'undercurl' },
        },
    },
    auto_integrations = true,
}

-- gruvbox-material is configured through globals, which must be set before loading
vim.g.gruvbox_material_background = 'soft' -- 'soft' | 'medium' | 'hard'
vim.g.gruvbox_material_foreground = 'material' -- 'material' | 'mix' | 'original'
-- Italics only for comments: the global switch covers everything else
vim.g.gruvbox_material_enable_italic = false
vim.g.gruvbox_material_disable_italic_comment = false
vim.g.gruvbox_material_better_performance = true

-- Float body, border and titles share one bg: gruvbox-material's darker bg_dim
-- (follows the soft/medium/hard setting), or transparent for other schemes
vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('float_bg', { clear = true }),
    callback = function()
        local float_bg = 'NONE'
        if vim.g.colors_name == 'gruvbox-material' then
            local palette = vim.fn['gruvbox_material#get_palette'](
                vim.g.gruvbox_material_background,
                vim.g.gruvbox_material_foreground,
                vim.empty_dict()
            )
            float_bg = palette.bg_dim[1]
        end
        local groups = {
            'NormalFloat',
            'FloatBorder',
            'FloatTitle',
            'MiniFilesTitle',
            'MiniFilesTitleFocused',
            'MiniPickBorderText',
            'MiniPickBorderBusy',
            'MiniPickPrompt',
            'MiniPickPromptPrefix',
            'MiniPickPromptCaret',
        }
        for _, name in ipairs(groups) do
            local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
            vim.api.nvim_set_hl(0, name, vim.tbl_extend('force', hl, { bg = float_bg }))
        end
    end,
})

local scheme = 'gruvbox-material'

vim.cmd.colorscheme(scheme)
