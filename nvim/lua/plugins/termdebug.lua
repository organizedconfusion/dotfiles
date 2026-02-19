-- [[ Termdebug Setup ]]

vim.cmd('packadd! termdebug')

local function start_remote_debug()
    vim.api.nvim_create_autocmd("User", {
        pattern = "TermdebugStartPost",
        once = true, -- This ensures it only runs once and then deletes itself
        callback = function()
            -- Find and close the program window
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.api.nvim_buf_get_name(buf):match("gdb program$") then
                    vim.api.nvim_win_close(win, true)
                    break
                end
            end
            vim.cmd("wincmd L")
            vim.cmd("Source")
        end,
    })
    vim.cmd('Termdebug')
end

-- Termdebug keymaps
vim.g.termdebugger = {
    'arm-none-eabi-gdb',
    '-q',
}

vim.keymap.set("n", "<F1>", function()
    start_remote_debug()
end, { noremap = true })

vim.keymap.set("n", "<F5>", function()
    vim.fn.TermDebugSendCommand('continue')
end)

vim.keymap.set("n", "<F8>", function()
    vim.cmd("Stop")
end)

vim.keymap.set("n", "<F9>", function()
    vim.fn.TermDebugSendCommand('step')
end)

vim.keymap.set("n", "<F10>", function()
    vim.fn.TermDebugSendCommand('next')
end)

vim.keymap.set("n", "<F12>", function()
    vim.fn.TermDebugSendCommand('finish')
end)

vim.api.nvim_create_autocmd("User", {
    pattern = "TermdebugStartPre",
    command = "set norelativenumber",
})
