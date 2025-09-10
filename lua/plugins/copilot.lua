return {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
        local ok, copilot = pcall(require, 'copilot')
        if not ok then return end

        copilot.setup({
            suggestion = {
                enabled = true,
                auto_trigger = true,
                hide_during_completion = true,
                keymap = {
                    accept = '<C-e>',
                    next = '<M-]>',
                    prev = '<M-[>',
                },
            },
            panel = { enabled = false },
            filetypes = {
                markdown = true,
                help = true,
                ['*'] = true,
            },
        })
    end,
}
