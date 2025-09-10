vim.pack.add({
    { src = 'https://github.com/nvim-tree/nvim-tree.lua' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' }, -- optional, for file icons
})

local ok, nvim_tree = pcall(require, 'nvim-tree')
if ok then
    nvim_tree.setup({
        sync_root_with_cwd = true,
        view = { width = 32, side = 'right' },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
        update_focused_file = { enable = true },
        actions = {
            open_file = {
                quit_on_open = true,
            }
        }
    })
    local api = require('nvim-tree.api')
    vim.keymap.set('n', '<leader>e', api.tree.toggle)
else
    vim.notify('nvim-tree not installed/loaded', vim.log.levels.WARN)
end

