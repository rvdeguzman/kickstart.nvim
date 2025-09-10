vim.pack.add({
    { src = 'https://github.com/stevearc/oil.nvim' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
})

local ok, oil = pcall(require, 'oil')
if ok then
    oil.setup({
        view_options = {
            show_hidden = true,
        },
    })
    vim.keymap.set('n', '-', '<cmd>Oil<CR>')
else
    vim.notify('oil.nvim not installed/loaded', vim.log.levels.WARN)
end

