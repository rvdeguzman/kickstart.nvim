vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>Q', '<cmd>qa!<CR>', { desc = 'Quit nvim' })
vim.keymap.set('n', '<C-q>', '<cmd>qa!<CR>', { desc = 'Quit nvim' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
-- Split window mappings
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<CR>', { desc = 'Split window [V]ertically' })
vim.keymap.set('n', '<leader>wh', '<cmd>split<CR>', { desc = 'Split window [H]orizontally' })
-- diagnostic jumping
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
-- ai
--
-- AI tool keymappings with distinct prefixes to avoid confusion
-- Copilot keymaps
vim.keymap.set('n', '<leader>cp', ':Copilot<CR>', { desc = 'Open [C]o[p]ilot', silent = true })
vim.keymap.set('n', '<leader>ce', ':Copilot enable<CR>', { desc = '[C]opilot [E]nable', silent = true })
vim.keymap.set('n', '<leader>cd', ':Copilot disable<CR>', { desc = '[C]opilot [D]isable', silent = true })

-- CodeCompanion keymaps (using 'cc' prefix)
vim.keymap.set({ 'n', 'v' }, '<leader>cca', '<cmd>CodeCompanionActions<cr>', { desc = '[C]ode[C]ompanion [A]ctions', noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>cct', '<cmd>CodeCompanionChat Toggle<cr>', { desc = '[C]ode[C]ompanion Chat [T]oggle', noremap = true, silent = true })
vim.keymap.set('v', '<leader>cca', '<cmd>CodeCompanionChat Add<cr>', { desc = '[C]ode[C]ompanion Chat [A]dd Selection', noremap = true, silent = true })
vim.keymap.set('n', '<leader>ccs', '<cmd>CodeCompanionSummarize<cr>', { desc = '[C]ode[C]ompanion [S]ummarize', noremap = true, silent = true })
vim.keymap.set('n', '<leader>ccf', '<cmd>CodeCompanionFix<cr>', { desc = '[C]ode[C]ompanion [F]ix', noremap = true, silent = true })

-- Avante keymaps (using 'a' prefix)
vim.keymap.set('n', '<leader>at', '<cmd>AvanteToggle<cr>', { desc = '[A]vante [T]oggle', noremap = true, silent = true })
vim.keymap.set('n', '<leader>aa', '<cmd>AvanteAsk<cr>', { desc = '[A]vante [A]sk', noremap = true, silent = true })
vim.keymap.set('v', '<leader>as', '<cmd>AvanteSubmit<cr>', { desc = '[A]vante [S]ubmit Selection', noremap = true, silent = true })
vim.keymap.set('n', '<leader>ar', '<cmd>AvanteReset<cr>', { desc = '[A]vante [R]eset Conversation', noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line (keep from original)
vim.cmd [[cab cc CodeCompanion]]
-- Add similar expansion for Avante
vim.cmd [[cab av Avante]]
