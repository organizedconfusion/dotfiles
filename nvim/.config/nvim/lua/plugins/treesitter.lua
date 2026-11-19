-- [[ treesitter setup ]]

-- [[ Parser installation ]]
require('nvim-treesitter').setup {
    -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
    install_dir = vim.fn.stdpath('data') .. '/site',
}

local augroup = vim.api.nvim_create_augroup('config_treesitter', { clear = true })

-- Languages to install parsers for and enable highlighting/folding on
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

-- Install any parsers from the list above that are missing
local installed = require('nvim-treesitter').get_installed('parsers')
local missing = vim.tbl_filter(function(lang)
    return not vim.list_contains(installed, lang)
end, langs)
if #missing > 0 then
    require('nvim-treesitter').install(missing)
end

-- [[ Highlighting and folding ]]
-- Start treesitter for the listed languages and fold by treesitter expression (all folds open)
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
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
        vim.wo.foldlevel = 99
    end,
})

-- [[ Context ]]
-- Pin the enclosing scope(s) to the top of the window
require('treesitter-context').setup({
    max_lines = 4,
    trim_scope = 'outer',
})

-- [[ Textobjects ]]
require('nvim-treesitter-textobjects').setup {
    select = {
        lookahead = true,
    },
}

local ts_select = require('nvim-treesitter-textobjects.select')
local ts_move = require('nvim-treesitter-textobjects.move')
local ts_swap = require('nvim-treesitter-textobjects.swap')
local ts_repeat_move = require('nvim-treesitter-textobjects.repeatable_move')
local map = vim.keymap.set

-- Map a visual/operator-pending textobject selection
local function map_select(lhs, query, desc)
    map({ 'x', 'o' }, lhs, function()
        ts_select.select_textobject(query, 'textobjects')
    end, { desc = desc })
end

-- Map a jump to the next/previous textobject; direction is 'next' or 'previous',
-- edge is 'start' or 'end', and group is the query file (defaults to 'textobjects')
local function map_move(lhs, direction, edge, query, desc, group)
    local jump = ts_move['goto_' .. direction .. '_' .. edge]
    map({ 'n', 'x', 'o' }, lhs, function()
        jump(query, group or 'textobjects')
    end, { desc = desc })
end

-- [[ Select keymaps ]]
-- a<key> selects the whole textobject, i<key> only its inside
map_select('ak', '@block.outer', 'Select around a block.')
map_select('ik', '@block.inner', 'Select inside a block.')
map_select('am', '@function.outer', 'Select around a function.')
map_select('im', '@function.inner', 'Select inside a function.')
map_select('aa', '@parameter.outer', 'Select around a parameter.')
map_select('ia', '@parameter.inner', 'Select inside a parameter.')
map_select('al', '@loop.outer', 'Select around a loop.')
map_select('il', '@loop.inner', 'Select inside a loop.')
map_select('ai', '@conditional.outer', 'Select around a conditional.')
map_select('ii', '@conditional.inner', 'Select inside a conditional.')
map_select('av', '@call.outer', 'Select around a function call.')
map_select('iv', '@call.inner', 'Select inside a function call.')


-- [[ Move keymaps ]]

-- Functions: ]m / [m jump to the next/previous start, ]M / [M to the next/previous end
map_move(']m', 'next', 'start', '@function.outer', 'Next function start.')
map_move('[m', 'previous', 'start', '@function.outer', 'Previous function start.')
map_move(']M', 'next', 'end', '@function.outer', 'Next function end.')
map_move('[M', 'previous', 'end', '@function.outer', 'Previous function end.')

-- Classes
map_move(']]', 'next', 'start', '@class.outer', 'Next class start.')
map_move('[[', 'previous', 'start', '@class.outer', 'Previous class start.')
map_move('][', 'next', 'end', '@class.outer', 'Next class end.')
map_move('[]', 'previous', 'end', '@class.outer', 'Previous class end.')

-- Parameters: lowercase lands inside the parameter, uppercase on the whole parameter
map_move(']a', 'next', 'start', '@parameter.inner', 'Next parameter (inner).')
map_move('[a', 'previous', 'start', '@parameter.inner', 'Previous parameter (inner).')
map_move(']A', 'next', 'start', '@parameter.outer', 'Next parameter (outer).')
map_move('[A', 'previous', 'start', '@parameter.outer', 'Previous parameter (outer).')

-- Conditionals, loops, blocks and folds
map_move(']i', 'next', 'start', '@conditional.outer', 'Next conditional.')
map_move('[i', 'previous', 'start', '@conditional.outer', 'Previous conditional.')
map_move(']o', 'next', 'start', '@loop.outer', 'Next loop.')
map_move('[o', 'previous', 'start', '@loop.outer', 'Previous loop.')
map_move(']k', 'next', 'start', '@block.outer', 'Next block.')
map_move('[k', 'previous', 'start', '@block.outer', 'Previous block.')
map_move(']z', 'next', 'start', '@fold', 'Next fold.', 'folds')
map_move('[z', 'previous', 'start', '@fold', 'Previous fold.', 'folds')

-- Jump up to the enclosing context line shown by treesitter-context
map('n', '[x', function()
    require('treesitter-context').go_to_context(vim.v.count1)
end, { silent = true, desc = 'Jump to the enclosing context.' })

-- [[ Swap keymaps ]]
map('n', '<leader>a', function()
    ts_swap.swap_next('@parameter.inner')
end, { desc = 'Swap the parameter with the next one.' })
map('n', '<leader>A', function()
    ts_swap.swap_previous('@parameter.inner')
end, { desc = 'Swap the parameter with the previous one.' })

-- [[ Repeatable movements ]]
-- ; and , repeat the last treesitter move (or f/F/t/T) in the direction it was going, the vim way
map({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move,
    { desc = 'Repeat the last move.' })
map({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite,
    { desc = 'Repeat the last move in the opposite direction.' })
map({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true, desc = 'Find character forward.' })
map({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true, desc = 'Find character backward.' })
map({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true, desc = 'Move until character forward.' })
map({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true, desc = 'Move until character backward.' })
