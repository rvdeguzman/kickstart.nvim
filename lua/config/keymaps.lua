vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('n', '<leader>Q', '<cmd>qa!<CR>', { desc = 'Quit nvim' })
vim.keymap.set('n', '<C-q>', '<cmd>qa!<CR>', { desc = 'Quit nvim' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Split window mappings
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<CR>', { desc = 'Split window [V]ertically' })
vim.keymap.set('n', '<leader>wh', '<cmd>split<CR>', { desc = 'Split window [H]orizontally' })