return {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
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
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local buf = args.buf
                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
                    end

                    map('n', 'K', vim.lsp.buf.hover)
                    map('n', 'gD', vim.lsp.buf.declaration)
                    map('n', '<leader>rn', vim.lsp.buf.rename)
                    map('n', '<leader>ca', vim.lsp.buf.code_action)
                    map('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end)
                    map('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end)
                    map('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end)
                    map('n', '<leader>q', vim.diagnostic.setloclist)
                    map('i', '<C-s>', vim.lsp.buf.signature_help)
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-context",
        },
        config = function()
            local ok, ts = pcall(require, 'nvim-treesitter.configs')
            if not ok then
                vim.notify('nvim-treesitter not loaded', vim.log.levels.WARN)
                return
            end

            ts.setup({
                ensure_installed = {
                    'lua', 'vim', 'vimdoc',
                    'javascript', 'typescript',
                    'c', 'cpp',
                    'python',
                },
                highlight = { enable = true, additional_vim_regex_highlighting = false },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<CR>',
                        node_incremental = '<CR>',
                        node_decremental = '<BS>',
                    },
                },
            })

            -- treesitter folding
            vim.opt.foldmethod = 'expr'
            vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
            vim.opt.foldenable = true
        end,
    },
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        config = function()
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
        end,
    },
    {
        "nvim-flutter/flutter-tools.nvim",
        ft = "dart",
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
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
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),

                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif has_ls and luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),

                    ['<S-Tab>'] = cmp.mapping(function(fallback)
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
        end,
    },
    -- mason
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
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

            -- Setup mason-lspconfig
            require('mason-lspconfig').setup({
                ensure_installed = { 'lua_ls', 'ts_ls', 'clangd', 'ruff', 'pyright' },
                automatic_enable = true,
            })
        end,
    },
    -- nvim-autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
        config = function()
            local ok, npairs = pcall(require, 'nvim-autopairs')
            if not ok then return end

            npairs.setup({})

            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end,
    }
