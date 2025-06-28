return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
              require('luasnip.loaders.from_lua').load { paths = vim.fn.stdpath 'config' .. '/lua/rv/snippets' }
              -- Load your custom snippets
              require('luasnip').filetype_extend('dart', { 'flutter' })
              -- Add HTML, CSS, JavaScript, TypeScript, and Python snippet support
              require('luasnip').filetype_extend('html', { 'html-es6-snippets' })
              require('luasnip').filetype_extend('css', { 'css' })
              require('luasnip').filetype_extend('javascript', { 'javascript', 'js-es6-snippets' })
              require('luasnip').filetype_extend('typescript', { 'typescript', 'ts-es6-snippets' })
              require('luasnip').filetype_extend('python', { 'python' })
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      'Nash0x7E2/awesome-flutter-snippets',

      -- Adds other completion capabilities.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        formatting = {
          format = function(entry, vim_item)
            -- Add source indicators to completion menu
            vim_item.menu = ({
              buffer = '[Buffer]',
              nvim_lsp = '[LSP]',
              luasnip = '[Snippet]',
              copilot = '[Copilot]',
              codecompanion = '[CodeComp]',
              path = '[Path]',
            })[entry.source.name]
            return vim_item
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          ['<CR>'] = cmp.mapping.confirm { select = true },

          -- replaces the default <C-n> and <C-p> mappings
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-k>'] = cmp.mapping.select_prev_item(),

          -- Think of <tab> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <tab> will move you to the right of each of the expansion locations.
          -- <s-tab> is similar, except moving you backwards.

          ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<C-Space>'] = cmp.mapping.complete {},

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp', priority = 1000 },
          { name = 'copilot', priority = 900 },
          { name = 'luasnip', priority = 800 },
          { name = 'buffer', priority = 700 },
          { name = 'path', priority = 600 },
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            priority = 500,
          },
        },
        -- Add filetype specific sources
        filetype_specific_source_groups = {
          codecompanion = {
            { name = 'codecompanion' },
          },
        },
        experimental = {
          ghost_text = true, -- Show ghost text preview
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
