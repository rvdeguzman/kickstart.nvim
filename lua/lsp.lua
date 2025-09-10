vim.pack.add({
    { src = 'https://github.com/williamboman/mason.nvim' },
    { src = 'https://github.com/williamboman/mason-lspconfig.nvim' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
})

require('mason').setup()

pcall(function()
    require('mason-tool-installer').setup({
        ensure_installed = {
            'stylua',
            'prettier',
        },
        run_on_start = true,
    })
end)


vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local buf = args.buf
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
        end

        map('n', 'K', vim.lsp.buf.hover)
        map('n', 'gD', vim.lsp.buf.declaration)
        -- map('n', 'gd', vim.lsp.buf.definition)
        -- map('n', 'gi', vim.lsp.buf.implementation)
        -- map('n', 'gr', vim.lsp.buf.references)
        -- map('n', 'gt', vim.lsp.buf.type_definition)
        map('n', '<leader>rn', vim.lsp.buf.rename)
        map('n', '<leader>ca', vim.lsp.buf.code_action)
        map('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end)
        map('n', '[d', function() vim.diagnostic.jump({count = -1, float=true}) end)
        map('n', ']d', function() vim.diagnostic.jump({count = 1, float=true}) end)
        map('n', '<leader>q', vim.diagnostic.setloclist)
        map('i', '<C-s>', vim.lsp.buf.signature_help)
    end,
})

local lspconfig = require('lspconfig')
local mlsp = require('mason-lspconfig')

vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter',        build = ':TSUpdate' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
})

do
    local ok, ts = pcall(require, 'nvim-treesitter.configs')
    if not ok then
        vim.notify('nvim-treesitter not loaded', vim.log.levels.WARN)
        return
    end

    ts.setup({
        ensure_installed      = {
            'lua', 'vim', 'vimdoc',
            'javascript', 'typescript',
            'c', 'cpp',
            'python',
        },
        highlight             = { enable = true, additional_vim_regex_highlighting = false },
        indent                = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection   = '<CR>',
                node_incremental = '<CR>',
                node_decremental = '<BS>',
            },
        },
    })
end

-- treesitter folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- copilot
vim.pack.add({
    { src = 'https://github.com/zbirenbaum/copilot.lua' },
})

do
    local ok, copilot = pcall(require, 'copilot')
    if not ok then return end
    copilot.setup({
        suggestion = {
            enabled = true,
            auto_trigger = true,
            hide_during_completion = true,
            keymap = {
                accept = '<C-e>',
                next = '<M-]>',
                prev = '<M-[>',
            },
        },
        panel = { enabled = false },
        filetypes = {
            markdown = true,
            help = true,
            ['*'] = true,
        },
    })
end

-- flutter
vim.pack.add({
    { src = 'https://github.com/nvim-flutter/flutter-tools.nvim'}
})

-- cmp
vim.pack.add({
    { src = 'https://github.com/hrsh7th/nvim-cmp' },
    { src = 'https://github.com/hrsh7th/cmp-nvim-lsp-signature-help' },
    { src = 'https://github.com/hrsh7th/cmp-nvim-lsp' },
    { src = 'https://github.com/hrsh7th/cmp-buffer' },
    { src = 'https://github.com/hrsh7th/cmp-path' },
    { src = 'https://github.com/L3MON4D3/LuaSnip' },
    { src = 'https://github.com/saadparwaiz1/cmp_luasnip' },
})

do
    local ok, cmp = pcall(require, 'cmp')
    if not ok then return end

    local has_ls, luasnip = pcall(require, 'luasnip')

    vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

    cmp.setup({
        snippet = {
            expand = function(args)
                if has_ls then luasnip.lsp_expand(args.body) end
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>']      = cmp.mapping.confirm({ select = true }),

            ['<Tab>']     = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif has_ls and luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),

            ['<S-Tab>']   = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif has_ls and luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'nvim_lsp_signature_help' },
        }, {
            { name = 'path' },
            { name = 'buffer' },
        }),
    })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp_lsp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok_cmp_lsp then
    capabilities = cmp_lsp.default_capabilities(capabilities)
end

vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config('ts_ls', {
  capabilities = capabilities,
  settings = {
    javascript = { suggest = { autoImports = true } },
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayVariableTypeHints = true,
      },
    },
  },
})

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls', 'ts_ls', 'clangd', 'ruff', 'pyright' },
  automatic_enable = true,   -- mason-lspconfig will `vim.lsp.enable()` installed servers
})

vim.pack.add({
    { src = 'https://github.com/windwp/nvim-autopairs' },
})

do
    local ok, npairs = pcall(require, 'nvim-autopairs')
    if not ok then return end

    npairs.setup({})

    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
end
