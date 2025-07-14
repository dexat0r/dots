-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
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

vim.opt.relativenumber = true


-- mappings
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Line Down in Visual Mode" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Line Up in Visual Mode" })
vim.keymap.set("n", "<leader>w", ":w<CR>",   { desc = "Quick save" })
vim.keymap.set('n', '<leader>ss', ':s/\\v',  { desc = "search and replace on line" })
vim.keymap.set('n', '<leader>SS', ':%s/\\v', { desc = "search and replace in file" })

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
			lazy = false, -- REQUIRED: tell lazy.nvim to start this plugin at startup
			dependencies = {
				-- main one
				{ "ms-jpq/coq_nvim", branch = "coq" },
				-- 9000+ Snippets
				{ "ms-jpq/coq.artifacts", branch = "artifacts" },
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
				-- Your LSP settings here
			end,
		},

		{
			"xiyaowong/transparent.nvim",
			lazy = false,
			config = function ()
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
		}
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
