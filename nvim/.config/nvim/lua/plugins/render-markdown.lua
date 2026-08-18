require('render-markdown').setup({
    file_types = { "markdown", "codecompanion" },
    completions = { lsp = { enabled = true } },
})
