-- [[ treesitter setup ]]
require('nvim-treesitter').setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/site'
}

local augroup = vim.api.nvim_create_augroup('config_treesitter', { clear = true })

local langs = {
    'bash',
    'c',
    'cmake',
    'comment',
    'cpp',
    'csv',
    'diff',
    'git_config',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'json',
    'latex',
    'linkerscript',
    'lua',
    'make',
    'markdown',
    'markdown_inline',
    'python',
    'vim',
    'vimdoc',
    'yaml',
}

local installed = require('nvim-treesitter').get_installed('parsers')
local missing = vim.tbl_filter(function(lang)
    return not vim.list_contains(installed, lang)
end, langs)
if #missing > 0 then
    require('nvim-treesitter').install(missing)
end

vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang or not vim.list_contains(langs, lang) then
            return
        end
        if not pcall(vim.treesitter.start, args.buf, lang) then
            return
        end
        --vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
        vim.wo.foldlevel = 99
    end,
})

require("treesitter-context").setup({
    max_lines = 4,
    trim_scope = 'outer',
    separator = '─'
})

vim.api.nvim_create_autocmd("ColorScheme", {
    group = augroup,
    callback = function()
        local nontext = vim.api.nvim_get_hl(0, { name = 'NonText' })

        vim.api.nvim_set_hl(0, 'TreesitterContextSeparator', {
            fg = nontext.fg,
            bg = 'none',
        })

        local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
        vim.api.nvim_set_hl(0, 'TreesitterContext', {
            fg = normal.fg,
            bg = 'none',
        })
    end,
})

require("nvim-treesitter-textobjects").setup {
    select = {
        lookahead = true,
    },
}

-- [[ KEYMAPPINGS ]]

-- Select keymaps
vim.keymap.set({ "x", "o" }, "ak", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@block.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ik", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@block.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "am", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "im", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "aa", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@parameter.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ia", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@parameter.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "al", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@loop.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "il", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@loop.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ai", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@conditional.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ii", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@conditional.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "av", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@call.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "iv", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@call.inner", "textobjects")
end)


-- Move keymaps

-- move by function
vim.keymap.set({ "n", "x", "o" }, "]m", function()
    require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[m", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]M", function()
    require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[M", function()
    require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
end)
-- move by class
vim.keymap.set({ "n", "x", "o" }, "]]", function()
    require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[[", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "][", function()
    require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[]", function()
    require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
end)

-- other moves
vim.keymap.set({ "n", "x", "o" }, "]a", function()
    require("nvim-treesitter-textobjects.move").goto_next_start({ "@parameter.inner" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[a", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start({ "@parameter.inner" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]A", function()
    require("nvim-treesitter-textobjects.move").goto_next_start({ "@parameter.outer" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[A", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start({ "@parameter.outer" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[i", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start({ "@conditional.outer" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]i", function()
    require("nvim-treesitter-textobjects.move").goto_next_start({ "@conditional.outer" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[z", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start({ "@fold" }, "folds")
end)
vim.keymap.set({ "n", "x", "o" }, "]z", function()
    require("nvim-treesitter-textobjects.move").goto_next_start({ "@fold" }, "folds")
end)
vim.keymap.set({ "n", "x", "o" }, "[o", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start({ "@loop.outer" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]o", function()
    require("nvim-treesitter-textobjects.move").goto_next_start({ "@loop.outer" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[k", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start({ "@block.outer" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]k", function()
    require("nvim-treesitter-textobjects.move").goto_next_start({ "@block.outer" }, "textobjects")
end)

vim.keymap.set("n", "[x", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })

-- Swap keymaps
vim.keymap.set("n", "<leader>a", function()
    require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
end)
vim.keymap.set("n", "<leader>A", function()
    require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner"
end)

-- Tresitter repeat movements the vim way: ; goes to the direction you were moving.
local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
