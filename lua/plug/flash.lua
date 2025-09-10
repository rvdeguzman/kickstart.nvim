vim.pack.add({
    { src = 'https://github.com/folke/flash.nvim' },
})

local ok, flash = pcall(require, 'flash')
if not ok then
    vim.notify('flash.nvim not found (not loaded yet?)', vim.log.levels.WARN)
else
    flash.setup()

    vim.keymap.set({ 'n', 'x', 'o' }, 'f', function()
        flash.jump()
    end)

    vim.keymap.set('o', 'r', function()
        flash.remote()
    end)

    vim.keymap.set({ 'n', 'x', 'o' }, 'F', function()
        flash.treesitter()
    end)
end
