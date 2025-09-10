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
        defaults = {
            border = true,
            borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        }
    })

    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader><leader>', builtin.find_files)
    vim.keymap.set('n', '<leader>,', builtin.live_grep)
    vim.keymap.set('n', '<leader>.', builtin.oldfiles)
    vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_cursor({
            previewer = false,
        }))
    end)
    vim.keymap.set('n', '<leader>ss', function()
        builtin.lsp_document_symbols()
    end)

    vim.keymap.set('n', '<leader>st', builtin.treesitter)
    
    -- telescope lsp
    vim.keymap.set('n', 'gr', builtin.lsp_references)
    vim.keymap.set('n', 'gd', builtin.lsp_definitions)
    vim.keymap.set('n', 'gi', builtin.lsp_implementations)
    vim.keymap.set('n', 'gt', builtin.lsp_type_definitions)

    vim.keymap.set('n', '<leader>sf', function()
        builtin.lsp_document_symbols({
            initial_text = '',
            ignore_symbols = {
                'variable',
                'constant',
                'string',
                'number',
                'object',
                'field',
                'property',
                'key',
                'array',
                'boolean',
                'package',
            },
        })
    end)
    vim.keymap.set('n', '<leader>ws', builtin.lsp_dynamic_workspace_symbols)
else
    vim.notify('telescope.nvim not found (not loaded yet?)', vim.log.levels.WARN)
end
