-- [[ treesitter setup ]]
require('nvim-treesitter').setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/site'
}

vim.keymap.set({ 'x' }, '[n', function()
    require 'vim.treesitter._select'.select_prev(vim.v.count1)
end, { desc = 'Select previous treesitter node' })

vim.keymap.set({ 'x' }, ']n', function()
    require 'vim.treesitter._select'.select_next(vim.v.count1)
end, { desc = 'Select next treesitter node' })

vim.keymap.set({ 'x', 'o' }, 'an', function()
    if vim.treesitter.get_parser(nil, nil, { error = false }) then
        require 'vim.treesitter._select'.select_parent(vim.v.count1)
    else
        vim.lsp.buf.selection_range(vim.v.count1)
    end
end, { desc = 'Select parent treesitter node or outer incremental lsp selections' })

vim.keymap.set({ 'x', 'o' }, 'in', function()
    if vim.treesitter.get_parser(nil, nil, { error = false }) then
        require 'vim.treesitter._select'.select_child(vim.v.count1)
    else
        vim.lsp.buf.selection_range(-vim.v.count1)
    end
end, { desc = 'Select child treesitter node or inner incremental lsp selections' })

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

for _, lang in ipairs(langs) do
    require("nvim-treesitter").install(lang)
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = langs,
    callback = function(args)
        vim.treesitter.start(args.buf)
        --vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
        vim.wo.foldlevel = 99
    end,
})

require("treesitter-context").setup({
    max_lines = 4,
    trim_scope = 'outer',
})

require("nvim-treesitter-textobjects").setup {
    select = {
        lookahead = true,
    },
}

-- [[ KEYMAPPINGS ]]

-- Select keymaps
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
vim.keymap.set({ "x", "o" }, "ao", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@block.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "io", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@block.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "as", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@scope.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "is", function()
    require "nvim-treesitter-textobjects.select".select_textobject("@scope.inner", "textobjects")
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
vim.keymap.set({ "n", "x", "o" }, "]o", function()
    require("nvim-treesitter-textobjects.move").goto_next_start({ "@loop.outer" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[o", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start({ "@loop.outer" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]a", function()
    require("nvim-treesitter-textobjects.move").goto_next_start({ "@parameter.inner" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[a", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start({ "@parameter.inner" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[o", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start({ "@block.outer" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]o", function()
    require("nvim-treesitter-textobjects.move").goto_next_start({ "@block.outer" }, "textobjects")
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
vim.keymap.set({ "n", "x", "o" }, "[l", function()
    require("nvim-treesitter-textobjects.move").goto_previous_start({ "@loop.outer" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]l", function()
    require("nvim-treesitter-textobjects.move").goto_next_start({ "@loop.outer" }, "textobjects")
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

vim.keymap.set({ "n", "x", "o" }, "<leader>cx", function() require("treesitter-context").toggle() end)
