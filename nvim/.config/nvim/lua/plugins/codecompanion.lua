vim.g.copilot_enabled = false

require("codecompanion").setup({
    interactions = {
        chat = {
            adapter = "copilot"
        },
        cli = {
            auto_insert = true,
            reload = true,
            agent = "copilot",
            agents = {
                copilot = {
                    cmd = "copilot",
                    args = {},
                    description = "GitHub Copilot CLI",
                    provider = "terminal",
                },
            },
        },
    },
})

vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>cl", function()
    require("codecompanion").toggle_cli()
end, { desc = "Toggle the CLI agent", noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<leader>cp", function()
    return require("codecompanion").cli({ prompt = true })
end, { desc = "Prompt the CLI agent" })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<leader>ca", function()
  return require("codecompanion").cli("#{this}", { focus = false })
end, { desc = "Add context to the CLI agent" })

vim.keymap.set("n", "<leader>cd", function()
  return require("codecompanion").cli("#{diagnostics} Can you fix these?", { focus = false, submit = true })
end, { desc = "Send diagnostics to CLI agent" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*codecompanion*",
    callback = function(args)
        local buf = args.buf
        vim.schedule(function()
            local win = vim.fn.bufwinid(buf)
            if win == -1 then
                return
            end
            local opts = { scope = "local", win = win }
            vim.api.nvim_set_option_value("signcolumn", "no", opts)
            vim.api.nvim_set_option_value("number", false, opts)
            vim.api.nvim_set_option_value("relativenumber", false, opts)
            vim.api.nvim_set_option_value("fillchars", "eob: ,", opts)
        end)
    end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
    pattern = "*",
    callback = function(args)
        if vim.bo[args.buf].filetype == "codecompanion_cli" then
            vim.cmd.startinsert()
        end
    end,
})
