vim.lsp.enable({
    "bashls",
    "clangd",
    "gopls",
    "lua_ls",
    "nil_ls",
    "pyright",
    "ts_ls",
    "vue_ls",
})

local vue_plugin_path = os.getenv("VUE_TYPESCRIPT_PLUGIN_PATH")

vim.lsp.config("ts_ls", {
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
    },
    init_options = {
        hostInfo = "neovim",
        plugins = vue_plugin_path and {
            {
                name = "@vue/typescript-plugin",
                location = vue_plugin_path,
                languages = { "vue" },
            },
        } or nil,
    },
})

-- Prevent LSP from overwriting treesitter color settings
vim.highlight.priorities.semantic_tokens = 95

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
    callback = function(event)
        local bufnr = event.buf

        local function nmap(mode, keys, func, desc)
            if desc then
                desc = "LSP: " .. desc
            end
            vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
        end

        -- General LSP
        nmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
        nmap("n", "gr", require("telescope.builtin").lsp_references, "Go to references")

        -- Diagnostics
        nmap("n", "<leader>df", vim.diagnostic.open_float, "Open floating diagnostic")
        nmap("n", "<leader>dn", vim.diagnostic.goto_next, "Next diagnostic")
        nmap("n", "<leader>dp", vim.diagnostic.goto_prev, "Previous diagnostic")
        nmap("n", "<leader>dd", vim.cmd.ToggleDiagnostics, "Toggle diagnostics")

        -- Refactoring
        nmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        nmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")

        -- Help
        nmap("n", "K", vim.lsp.buf.hover, "Hover documentation")
        nmap("i", "<C-h>", vim.lsp.buf.signature_help, "Signature help")
    end,
})

vim.diagnostic.config({
    virtual_text = true,
    underline = false,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.INFO] = "»",
            [vim.diagnostic.severity.HINT] = "⚑",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})
