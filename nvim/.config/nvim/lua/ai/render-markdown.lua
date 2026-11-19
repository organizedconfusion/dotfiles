-- [[ render-markdown setup ]]

-- Render markdown in CodeCompanion chat buffers and offer its completions through LSP
require('render-markdown').setup({
    file_types = { 'codecompanion' },
    completions = { lsp = { enabled = true } },
})
