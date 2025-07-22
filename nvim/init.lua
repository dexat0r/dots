-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Options
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.scrolloff = 15


-- mappings
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Line Down in Visual Mode" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Line Up in Visual Mode" })
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Quick save" })
vim.keymap.set('n', '<leader>ss', ':s/\\v', { desc = "search and replace on line" })
vim.keymap.set('n', '<leader>SS', ':%s/\\v', { desc = "search and replace in file" })
vim.keymap.set('n', '<leader>e', ':lua MiniFiles.open()<CR>', { desc = "Open Mini Files navigation", silent = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = "C-d with zz" })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = "C-u with zz" })

vim.keymap.set({ 'n', 'i' }, '<Up>', function() vim.notify("Use k", "info", { title = "Are you dumb?" }) end,
    { desc = "Disable Up key" })
vim.keymap.set({ 'n', 'i' }, '<Down>', function() vim.notify("Use j", "info", { title = "Are you dumb?" }) end,
    { desc = "Disable Down key" })
vim.keymap.set({ 'n', 'i' }, '<Left>', function() vim.notify("Use l", "info", { title = "Are you dumb?" }) end,
    { desc = "Disable Left key" })
vim.keymap.set({ 'n', 'i' }, '<Right>', function() vim.notify("Use h", "info", { title = "Are you dumb?" }) end,
    { desc = "Disable Right key" })

-- Splits
vim.keymap.set("n", "<S-Tab>", "<C-w>w", { desc = "Cycle buffer" })
vim.keymap.set("n", "<leader>c", ":close<CR>", { desc = "Close splitted buffer" })
vim.keymap.set("n", "<leader>|", "<C-w>v", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split horizaontal" })

-- Tabs
vim.keymap.set("n", "<leader>t", ":tabnew<CR>", { desc = "Create new tab" })
vim.keymap.set("n", "<Tab>", ":tabnext<CR>", { desc = "Go to next tab" })

-- Esc
vim.keymap.set("t", "jj", "<C-\\><C-n>", { desc = "Leave insert mode", noremap = true })
vim.keymap.set("i", "jj", "<ESC>", { desc = "Leave insert mode", noremap = true })

-- LSP
vim.keymap.set("n", "<F4>", "<Cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Execute code action" })
vim.keymap.set("n", "<F3>", "<Cmd>lua vim.lsp.buf.format({async = true})<CR>", { desc = "Format file" })
vim.keymap.set("n", "<F2>", "<Cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename symbol" })

vim.diagnostic.config({ virtual_text = true })

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- add your plugins here
        {
            "mason-org/mason.nvim",
            opts = {}
        },

        {
            "mason-org/mason-lspconfig.nvim",
            opts = {},
            dependencies = {
                { "mason-org/mason.nvim", opts = {} },
                "neovim/nvim-lspconfig",
            },
        },

        {
            "neovim/nvim-lspconfig", -- REQUIRED: for native Neovim LSP integration
            lazy = false,            -- REQUIRED: tell lazy.nvim to start this plugin at startup
            dependencies = {
                -- main one
                { "ms-jpq/coq_nvim",       branch = "coq" },
                -- 9000+ Snippets
                { "ms-jpq/coq.artifacts",  branch = "artifacts" },
                -- lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
                -- Need to **configure separately**
                { 'ms-jpq/coq.thirdparty', branch = "3p" }
                -- - shell repl
                -- - nvim lua api
                -- - scientific calculator
                -- - comment banner
                -- - etc
            },
            init = function()
                vim.g.coq_settings = {
                    auto_start = 'shut-up', -- if you want to start COQ at startup
                    -- Your COQ settings here
                }
            end,
            config = function()
                local capabilities = vim.lsp.protocol.make_client_capabilities()
                capabilities.textDocument.foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true
                }
                local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
                for _, ls in ipairs(language_servers) do
                    require('lspconfig')[ls].setup({
                        capabilities = capabilities
                        -- you can add other fields for setting up lsp server in this table
                    })
                end
            end
        },

        {
            "xiyaowong/transparent.nvim",
            lazy = false,
            config = function()
                -- require('transparent').clear_prefix('lualine')
            end
        },

        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            opts = {}
        },

        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            opts = {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            },
            keys = {
                {
                    "<leader>?",
                    function()
                        require("which-key").show({ global = false })
                    end,
                    desc = "Buffer Local Keymaps (which-key)",
                },
            },
        },

        {
            'echasnovski/mini.nvim',
            version = false,
            config = function()
                require("mini.files").setup {}
                require("mini.surround").setup {}
                require('mini.starter').setup()
            end
        },

        {
            'Wansmer/treesj',
            keys = {
                '<space>m',
                '<space>j',
                '<space>s',
            },
            dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
            config = function()
                require("treesj").setup({})
            end,
        },

        {
            "nvim-treesitter/nvim-treesitter",
            branch = 'master',
            lazy = false,
            build = ":TSUpdate",
        },

        {
            'marko-cerovac/material.nvim',
            config = function()
                require("material").setup({})
                vim.cmd 'colorscheme material'
                vim.g.material_style = 'darker'
            end
        },

        {
            'rcarriga/nvim-notify',
            config = function()
                require("notify").setup({
                    background_colour = "#000000"
                })
                vim.notify = require("notify")
            end
        },

        {
            "karb94/neoscroll.nvim",
            opts = {},
        },

        {
            "f-person/git-blame.nvim",
            -- load the plugin at startup
            event = "VeryLazy",
            -- Because of the keys part, you will be lazy loading this plugin.
            -- The plugin will only load once one of the keys is used.
            -- If you want to load the plugin at startup, add something like event = "VeryLazy",
            -- or lazy = false. One of both options will work.
            opts = {
                -- your configuration comes here
                -- for example
                enabled = true, -- if you want to enable the plugin
                message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
                date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
                virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
            }

        },

        {
            'kevinhwang91/nvim-ufo',
            dependencies = {
                'kevinhwang91/promise-async'
            },
            config = function()
                vim.o.foldcolumn = '1' -- '0' is not bad
                vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
                vim.o.foldlevelstart = 99
                vim.o.foldenable = true

                vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
                vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

                require('ufo').setup()
            end
        },

        {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.8',
            dependencies = {
                'nvim-lua/plenary.nvim',
                'nvim-telescope/telescope-file-browser.nvim',
            },
            config = function()
                local builtin = require('telescope.builtin')

                vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
                vim.keymap.set('n', '<C-p>', builtin.git_files, {})
                vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
                vim.keymap.set("n", "<space>fb", ":Telescope file_browser<CR>")

                require("telescope").setup(
                    {
                        defaults = {
                            layout_strategy = 'vertical',
                            layout_config = {
                                width = 90,
                                height = 40,
                                preview_cutoff = 0
                            }
                        }
                    }
                )

                require("telescope").load_extension "file_browser"
            end
        },

        {
            'windwp/nvim-autopairs',
            event = "InsertEnter",
            opts = {
                map_cr = false
            },
            -- use opts = {} for passing setup options
            -- this is equivalent to setup({}) function
        }
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})
