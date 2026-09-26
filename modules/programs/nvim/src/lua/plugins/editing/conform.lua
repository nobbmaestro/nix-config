vim.keymap.set("n", "<leader>f", function()
    local ok = require("conform").format({ lsp_format = "fallback" })

    if ok then
        vim.notify("Formatting done...", vim.log.levels.INFO, { title = "conform.nvim" })
    else
        vim.notify("Failed to format", vim.log.levels.ERROR, { title = "conform.nvim" })
    end
end, { desc = "Format buffer" })

require("conform").setup({
    formatters = {
        robotidy = {
            command = "robotidy",
            args = { "$FILENAME" },
            stdin = false,
        },
    },

    formatters_by_ft = {
        arduino = { "clang_format" },
        bash = { "shfmt" },
        c = { "clang_format" },
        go = { "goimports", "golines", "gofmt" },
        lua = { "stylua" },
        nix = { "nixfmt" },
        python = { "ruff_organize_imports", "ruff_format" },
        robot = { "robotidy" },

        markdown = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
    },
})
