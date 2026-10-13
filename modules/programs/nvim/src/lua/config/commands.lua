-- toggle virtual text diagnostics
vim.api.nvim_create_user_command("ToggleDiagnostics", function()
    local current_config = vim.diagnostic.config()
    local enabled = not current_config.virtual_text
    vim.diagnostic.config({ virtual_text = enabled })

    if enabled then
        print("Diagnostics enabled")
    else
        print("Diagnostics disabled")
    end
end, { nargs = 0 })

-- run rsyncer
vim.api.nvim_create_user_command("RemoteSync", function()
    local output = vim.fn.system("rsyncer")
    local exit_code = vim.v.shell_error

    if exit_code == 0 then
        vim.notify("RemoteSync success" .. output, vim.log.levels.INFO)
    else
        vim.notify("RemoteSync failed with exit code " .. exit_code .. ":\n" .. output, vim.log.levels.ERROR)
    end
end, { nargs = 0 })
