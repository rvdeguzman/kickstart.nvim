return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'hrsh7th/nvim-cmp',
    {
      'MeanderingProgrammer/render-markdown.nvim',
      ft = { 'markdown', 'codecompanion' },
    },
  },
  config = function()
    require('codecompanion').setup {
      adapters = {
        ollama = function()
          return require('codecompanion.adapters').extend('ollama', {
            name = 'ollama',
            url = 'http://localhost:11434/v1/chat/completions',
            headers = {
              ['Content-Type'] = 'application/json',
            },
            parameters = {
              model = 'qwen2.5-coder:7b',
              temperature = 0.1,
              max_tokens = 4096,
            },
          })
        end,
        chat = {
          -- Use Ollama as primary chat adapter
          ollama = {
            model = 'qwen2.5-coder:7b',
            temperature = 0.1,
          },
          -- Keep Claude as backup
          anthropic = {
            model = 'claude-3-7-sonnet-20250219',
            temperature = 0,
          },
        },
        inline = {
          -- Use Ollama for inline completions
          ollama = {
            model = 'qwen2.5-coder:7b',
            temperature = 0.1,
          },
        },
      },
      strategies = {
        chat = {
          adapter = 'ollama', -- Default to Ollama
        },
        inline = {
          adapter = 'ollama',
        },
        agent = {
          adapter = 'ollama',
        },
      },
      -- Auto-adjust sidebars to avoid conflicts
      sidebar = {
        width = 50,
        position = 'right',
      },
      -- Set completions
      completions = {
        enabled = true,
        trigger_characters = { ':', '.' },
        use_modal = true,
      },
      -- Enables format-after-fix
      auto_format = true,
      -- Display options
      display = {
        action_palette = {
          width = 95,
          height = 10,
        },
        chat = {
          window = {
            layout = 'vertical', -- or 'horizontal'
            width = 0.45,
            height = 0.8,
          },
        },
      },
    }
  end,
}
