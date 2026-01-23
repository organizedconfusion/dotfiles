return {
    {
        "machakann/vim-sandwich",
        event = "VeryLazy",
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "Telescope",
        config = function()
            require("telescope").setup({})
        end,
    },
}
