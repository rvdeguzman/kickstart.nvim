vim.pack.add({ 
    { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
})
local ok, harpoon = pcall(require, 'harpoon')
if ok then
    harpoon:setup({
        menu = {
            width = vim.api.nvim_win_get_width(0) - 4,
        },
        settings = {
            save_on_toggle = true,
        },
    })

    vim.keymap.set('n', '<leader>ha', function()
        harpoon:list():add()
    end, { desc = 'Harpoon: Add file' })

    vim.keymap.set('n', '<leader>ho', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Harpoon: Quick menu' })

    for i = 1, 9 do
        vim.keymap.set('n', '<leader>' .. i, function()
            harpoon:list():select(i)
        end, { desc = 'Harpoon: Jump to ' .. i })
    end
else
    vim.notify('Harpoon not installed!', vim.log.levels.WARN)
end

