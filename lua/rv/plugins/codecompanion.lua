return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'hrsh7th/nvim-cmp', -- Make sure this is here for completion integration
  },
  config = function()
    require('codecompanion').setup {
      adapters = {
        chat = {
          anthropic = {
            model = 'claude-3-7-sonnet-20250219',
            temperature = 0,
          },
        },
      },
      -- Auto-adjust sidebars to avoid conflicts
      sidebar = {
        width = 50,
        position = 'right', -- To avoid conflicts with Avante's default position
      },
      -- Set completions
      completions = {
        enabled = true,
        trigger_characters = { ':', '.' },
        use_modal = true,
      },
      -- Enables format-after-fix
      auto_format = true,
    }
  end,
}
