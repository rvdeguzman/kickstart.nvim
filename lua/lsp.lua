vim.pack.add({
    { src = 'https://github.com/williamboman/mason.nvim' },
    { src = 'https://github.com/williamboman/mason-lspconfig.nvim' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
})

require('mason').setup()

pcall(function()
    require('mason-tool-installer').setup({
        ensure_installed = { 'stylua', 'prettier', },
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
        map('n', 'gd', vim.lsp.buf.definition)
        map('n', 'gD', vim.lsp.buf.declaration)
        map('n', 'gi', vim.lsp.buf.implementation)
        map('n', 'gr', vim.lsp.buf.references)
        map('n', 'gt', vim.lsp.buf.type_definition)
        map('n', '<leader>rn', vim.lsp.buf.rename)
        map('n', '<leader>ca', vim.lsp.buf.code_action)
        map('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end)
        map('n', '[d', vim.diagnostic.goto_prev)
        map('n', ']d', vim.diagnostic.goto_next)
        map('n', '<leader>q', vim.diagnostic.setloclist)

        local ok, tb = pcall(require, 'telescope.builtin')
        if ok then
            map('n', '<leader>ss', function()
                tb.lsp_document_symbols({ initial_text = '' })
            end)
            map('n', '<leader>sf', function()
                tb.lsp_document_symbols({
                    initial_text = '',
                    ignore_symbols = { 'variable' },
                })
            end)
            map('n', '<leader>sS', tb.lsp_dynamic_workspace_symbols)
        end
    end,
})

local lspconfig = require('lspconfig')
local mlsp = require('mason-lspconfig')

vim.pack.add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
}, { build = ':TSUpdate' })

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
    { src = 'https://github.com/zbirenbaum/copilot-cmp' },
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
                accept = '<C-]>',
                next = '<M-]>',
                prev = '<M-[>',
                dismiss = '<C-\\>',
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

pcall(function()
    require('copilot_cmp').setup()
end)

-- cmp
vim.pack.add({
    { src = 'https://github.com/hrsh7th/nvim-cmp' },
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
            ['<C-e>']     = cmp.mapping.abort(),
            ['<C-n>']     = cmp.mapping.select_next_item(),
            ['<C-p>']     = cmp.mapping.select_prev_item(),
            ['<Tab>']     = cmp.mapping(function(fb)
                if has_ls and luasnip.expand_or_jumpable() then luasnip.expand_or_jump() else fb() end
            end, { 'i', 's' }),
            ['<S-Tab>']   = cmp.mapping(function(fb)
                if has_ls and luasnip.jumpable(-1) then luasnip.jump(-1) else fb() end
            end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'copilot' },
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

mlsp.setup({
    ensure_installed = {
        'lua_ls',
        'ts_ls',
        'clangd',
        'ruff',
        'pyright',
    },
    handlers = {
        function(server)
            lspconfig[server].setup({
                capabilities = capabilities,
            })
        end,
    },
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
