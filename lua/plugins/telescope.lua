vim.pack.add({
    { src = 'https://github.com/nvim-telescope/telescope.nvim' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope-ui-select.nvim' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
})

local ok, telescope = pcall(require, 'telescope')
if ok then
    telescope.setup({
        extensions = {
            ['ui-select'] = require('telescope.themes').get_dropdown(),
        },
    })

    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>,', builtin.live_grep, { desc = 'Live grep' })
    vim.keymap.set('n', '<leader>.', builtin.oldfiles, { desc = 'Recent files' })
    vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
            winblend = 10, previewer = false,
        }))
    end, { desc = 'Fuzzy in current buffer' })
else
    vim.notify('telescope.nvim not found (not loaded yet?)', vim.log.levels.WARN)
end

