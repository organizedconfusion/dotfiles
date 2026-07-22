-- [[ Neovim Options ]]

local clean_mode = false

local my = {
    signcolumn = 'yes:1',
    laststatus = 2
}

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.ruler = true
vim.opt.list = false
vim.opt.listchars:append('space:·')
vim.opt.visualbell = true
vim.opt.showmatch = true
vim.opt.signcolumn = my.signcolumn
vim.opt.numberwidth = 4
vim.opt.winborder = 'rounded'
vim.opt.timeout = true
vim.opt.timeoutlen = 300
-- vim.opt.colorcolumn = '110'
vim.opt.mouse = 'a'
vim.opt.mousemoveevent = true
vim.opt.guicursor='n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-blinkon500-blinkoff500-TermCursor'
vim.opt.laststatus = my.laststatus
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Formatting
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.opt.linebreak = true
vim.opt.wrap = false
vim.opt.breakindent = true

vim.o.completeopt = 'menuone,noselect,fuzzy,nosort'
vim.o.complete = '.,w,b'
vim.o.pumheight = 20

vim.opt.fillchars = {
    diff = " ",
}

vim.g.c_syntax_for_h = 1

vim.o.exrc = true
vim.o.secure = true

local function with_linematch_disabled(fn)
  local old = vim.o.diffopt
  -- remove linematch completely
  vim.o.diffopt = old:gsub(",?linematch:%d+", ""):gsub(",?linematch", "")
  pcall(fn)
  vim.o.diffopt = old
end

vim.api.nvim_create_user_command("Diffget", function(opts)
  with_linematch_disabled(function()
    vim.cmd("diffget " .. opts.args)
  end)
end, { nargs = 1, complete = "buffer" })

vim.api.nvim_create_user_command("Diffput", function(opts)
  with_linematch_disabled(function()
    vim.cmd("diffput " .. opts.args)
  end)
end, { nargs = 1, complete = "buffer" })

vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
       if clean_mode or vim.bo.buftype ~= "" then
            return
        end

        vim.opt.relativenumber = false
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
        if clean_mode or vim.bo.buftype ~= "" then
            return
        end

        vim.opt.relativenumber = true
    end,
})

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.opt.clipboard = 'unnamedplus'
  end,
})

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.hl_op()
  end,
})

-- Clean / zen mode

local saved = {
    inlay_hints = nil,
    line_blame = nil,
}

local function toggle_clean_mode()
    if not clean_mode then

        -- save current states
        if vim.lsp.inlay_hint and vim.lsp.inlay_hint.is_enabled then
            saved.inlay_hints = vim.lsp.inlay_hint.is_enabled()
        end

        saved.line_blame = vim.b.gitsigns_current_line_blame

        clean_mode = true

        vim.diagnostic.enable(false)

        for _, win in ipairs(vim.api.nvim_list_wins()) do
            vim.wo[win].number = false
            vim.wo[win].relativenumber = false
            vim.wo[win].signcolumn = 'no'
        end

        vim.o.laststatus = 0
        vim.o.cmdheight = 0

        if vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(false)
        end

        pcall(function()
            require("treesitter-context").disable()
        end)

        vim.g.miniindentscope_disable = true

        pcall(function()
            require("gitsigns").toggle_current_line_blame(false)
        end)

    else
        clean_mode = false

        vim.diagnostic.enable(true)

        for _, win in ipairs(vim.api.nvim_list_wins()) do
            vim.wo[win].number = true
            vim.wo[win].relativenumber = true
            vim.wo[win].signcolumn = my.signcolumn
        end

        vim.o.laststatus = my.laststatus
        vim.o.cmdheight = 1

        if vim.lsp.inlay_hint and saved.inlay_hints ~= nil then
            vim.lsp.inlay_hint.enable(saved.inlay_hints)
        end

        pcall(function()
            require("treesitter-context").enable()
        end)

        vim.g.miniindentscope_disable = false

        pcall(function()
            if saved.line_blame ~= nil then
                require("gitsigns").toggle_current_line_blame(saved.line_blame)
            end
        end)
    end
end

vim.keymap.set("n", "<leader>tz", toggle_clean_mode, {
    desc = "Toggle clean mode",
})

