vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

vim.keymap.set("n", "<leader>wh", ":wincmd h<CR>")
vim.keymap.set("n", "<leader>wj", ":wincmd j<CR>")
vim.keymap.set("n", "<leader>wk", ":wincmd k<CR>")
vim.keymap.set("n", "<leader>wl", ":wincmd l<CR>")
vim.keymap.set("n", "<leader>wv", ":wincmd v<CR>")
vim.keymap.set("n", "<leader>ws", ":wincmd s<CR>")
vim.keymap.set("n", "<leader>wq", ":wincmd q<CR>")

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.hidden = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.termguicolors = true
vim.opt.spell = false
vim.opt.title = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.keymap.set("n", "<ESC>", "<cmd>nohlsearch<CR>")
vim.opt.incsearch = true
vim.opt.inccommand = "split"

vim.opt.cmdheight = 1
vim.opt.showmode = false
vim.opt.completeopt = "menu"

vim.opt.wildmode = "longest:full,full"
vim.opt.wrap = false
vim.opt.listchars = { tab = "»·", trail = "·" }
vim.opt.list = true
vim.opt.mouse = "a"
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4
vim.opt.joinspaces = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.clipboard = "unnamedplus"
vim.opt.confirm = true
vim.opt.exrc = true

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.history = 100 -- keep 500 lines of command line history

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
			config = function()
				vim.cmd.colorscheme("catppuccin-mocha")
			end,
		},
		-- {
		-- 	"ishan9299/nvim-solarized-lua",
		-- 	priority = 1000,
		-- 	config = function()
		-- 		vim.cmd.colorscheme("solarized")
		-- 	end,
		-- },
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				local configs = require("nvim-treesitter.configs")

				configs.setup({
					ensure_installed = {
						"bash",
						"elixir",
						"go",
						"html",
						"javascript",
						"lua",
						"markdown",
						"ruby",
						"rust",
						"vim",
						"vimdoc",
					},
					sync_install = false,
					auto_install = true,
					highlight = { enable = true },
					indent = { enable = true },
				})
			end,
		},
		{
			"nvim-telescope/telescope.nvim",
			event = "VeryLazy",
			tag = "0.1.5",
			dependencies = { "nvim-lua/plenary.nvim" },

			config = function()
				local actions = require("telescope.actions")
				local layout_actions = require("telescope.actions.layout")
				require("telescope").setup({
					defaults = {
						preview = { hide_on_startup = true },
						mappings = {
							i = {
								["<esc>"] = actions.close,
								["<C-v>"] = layout_actions.toggle_preview,
							},
						},
					},
				})

				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "<leader>b", function()
					builtin.buffers({ sort_lastused = true })
				end, { desc = "find buffers" })
				vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "find files" })
				vim.keymap.set("n", "<leader>r", builtin.oldfiles, { desc = "find recent files" })
				vim.keymap.set("n", "<leader>lg", builtin.live_grep, { desc = "live grep" })
				vim.keymap.set("n", "<leader>h", builtin.help_tags, { desc = "search help" })
				vim.keymap.set("n", "<leader>w", builtin.grep_string, { desc = "search current word" })

				-- Slightly advanced example of overriding default behavior and theme
				vim.keymap.set("n", "<leader>/", function()
					-- You can pass additional configuration to telescope to change theme, layout, etc.
					builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = false,
					}))
				end, { desc = "[/] Fuzzily search in current buffer" })
			end,
		},
		{
			"nvim-telescope/telescope-ui-select.nvim",
			config = function()
				local telescope = require("telescope")
				telescope.setup({
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown({}),
						},
					},
				})
				telescope.load_extension("ui-select")
			end,
		},
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			init = function()
				vim.o.timeout = true
				vim.o.timeoutlen = 300
			end,
			config = true, -- Runs `require("mason").setup()`
		},
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
				-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
			},
			config = function()
				vim.keymap.set("n", "<leader>t", ":Neotree toggle<cr>", { desc = "Neotree" })
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			-- If opts are defined then `require(<plugin>).setup(opts)` is run for us
			opts = {
				options = {
					icons_enabled = false,
					section_separators = "",
					component_separators = "",
				},
				sections = {
					lualine_c = { { "filename", path = 1 } },
				},
			},
		},
		-- Whole LSP config is based off
		-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/you-might-not-need-lsp-zero.md
		{
			"williamboman/mason.nvim",
			config = true, -- Runs `require("mason").setup()`
		},
		{
			"williamboman/mason-lspconfig.nvim",
			opts = {
				ensure_installed = { "lua_ls", "rust_analyzer", "gopls" },
			},
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/nvim-cmp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/cmp-nvim-lua",
				"L3MON4D3/LuaSnip",
				-- "folke/neodev.nvim",
				"j-hui/fidget.nvim",
			},
			config = function()
				-- require("neodev").setup({})
				require("fidget").setup({})

				local lspconfig = require("lspconfig")

				local default_capabilities = vim.lsp.protocol.make_client_capabilities()
				default_capabilities =
					vim.tbl_deep_extend("force", default_capabilities, require("cmp_nvim_lsp").default_capabilities())
				-- local default_capabilities = require("cmp_nvim_lsp").default_capabilities()

				lspconfig.rust_analyzer.setup({
					capabilities = default_capabilities,
				})

				lspconfig.gopls.setup({
					capabilities = default_capabilities,
				})

				lspconfig.lua_ls.setup({
					capabilities = default_capabilities,
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							diagnostics = {
								globals = { "vim" },
								disable = { "missing-fields" },
							},
							workspace = {
								checkThirdParty = false,
								library = {
									"${3rd}/luv/library",
									unpack(vim.api.nvim_get_runtime_file("", true)),
								},
								-- If lua_ls is really slow on your computer, you can try this instead:
								-- library = { vim.env.VIMRUNTIME },
							},
						},
					},
				})

				vim.diagnostic.config({
					virtual_text = { source = true },
					update_on_insert = true,
				})

				-- Global mappings.
				-- See `:help vim.diagnostic.*` for documentation on any of the below functions
				vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
				vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

				-- not sure if needed
				vim.g.virtual_text_enabled = true
				vim.diagnostic.config({
					virtual_text = vim.g.virtual_text_enabled,
				})

				vim.api.nvim_create_autocmd("LspAttach", {
					-- group = vim.api.nvim_create_augroup("UserLspConfig", {}),

					callback = function(event)
						local gen_opts = function(description)
							return { buffer = event.buf, desc = description }
						end

						-- Enable completion triggered by <c-x><c-o>
						vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

						-- Buffer local mappings.
						-- See `:help vim.lsp.*` for documentation on any of the below functions
						vim.keymap.set("n", "gd", vim.lsp.buf.definition, gen_opts("Goto definition"))
						vim.keymap.set("n", "gD", vim.lsp.buf.declaration, gen_opts("Goto declaration"))
						vim.keymap.set("n", "K", vim.lsp.buf.hover, gen_opts("LSP hover"))
						-- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, gen_opts("Goto implementation"))
						-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
						-- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
						-- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
						-- vim.keymap.set('n', '<space>wl', function()
						--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
						-- end, opts)
						-- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
						-- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
						vim.keymap.set({ "n", "v" }, "<space>la", vim.lsp.buf.code_action, gen_opts("Code actions"))
						-- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
						vim.keymap.set("n", "<space>lf", function()
							vim.lsp.buf.format({ async = true })
						end, { buffer = event.buf, desc = "Format buffer" })
					end,
				})

				local cmp = require("cmp")
				-- local luasnip = require("luasnip")
				-- luasnip.config.setup({})

				cmp.setup({
					sources = cmp.config.sources(
						{ { name = "nvim_lsp" } },
						{ { name = "buffer", option = { keyword_length = 4 } } }
					),
					completion = { completeopt = "menu,menuone,noinsert" },
					mapping = cmp.mapping.preset.insert({
						-- Select the next item
						["<C-n>"] = cmp.mapping.select_next_item(),
						-- Select the previous item
						["<C-p>"] = cmp.mapping.select_prev_item(),

						-- Accept currently selected item. Set `select` to `false`
						-- to only confirm explicitly selected items.
						["<C-y>"] = cmp.mapping.confirm({ select = true }),

						-- Ctrl + space triggers completion menu
						["<C-Space>"] = cmp.mapping.complete(),

						["<C-e>"] = cmp.mapping.abort(),
						["<C-b>"] = cmp.mapping.scroll_docs(-4),
						["<C-f>"] = cmp.mapping.scroll_docs(4),
					}),

					snippet = {
						expand = function(args)
							require("luasnip").lsp_expand(args.body)
						end,
					},

					experimental = {
						native_menu = false,
						ghost_text = true,
					},
				})

				-- Set configuration for specific filetype.
				cmp.setup.filetype("lua", {
					sources = cmp.config.sources({
						{ name = "nvim_lua" },
					}, {
						{ name = "buffer", option = { keyword_length = 4 } },
					}),
				})

				-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
				cmp.setup.cmdline({ "/", "?" }, {
					mapping = cmp.mapping.preset.cmdline(),
					sources = {
						{ name = "buffer" },
					},
				})

				-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
				cmp.setup.cmdline(":", {
					mapping = cmp.mapping.preset.cmdline(),
					sources = cmp.config.sources({
						{ name = "path" },
					}, {
						{ name = "cmdline" },
					}),
				})
			end,
		},
		{
			"nvimtools/none-ls.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				local null_ls = require("null-ls")
				null_ls.setup({
					sources = {
						-- require("mason-registry").get_package("stylua"):install()
						-- or do it manually through Mason's UI
						null_ls.builtins.formatting.stylua,
					},
				})
			end,
		},
		{
			"numToStr/Comment.nvim",
			opts = {},
		},
		{
			"kylechui/nvim-surround",
			version = "*", -- Use for stability; omit to use `main` branch for the latest features
			event = "VeryLazy",
			opts = {},
		},
		{
			"tpope/vim-fugitive",
		},
		{
			"lewis6991/gitsigns.nvim",
			opts = {
				-- Uncomment if you don't have nerd font
				-- signs = {
				--   add = { text = '+' },
				--   change = { text = '~' },
				--   delete = { text = '_' },
				--   topdelete = { text = '‾' },
				--   changedelete = { text = '~' },
				-- },
				current_line_blame_opts = {
					delay = 100,
					--virt_text_pos = "right_align"
				},
				on_attach = function(bfnr)
					local gs = package.loaded.gitsigns

					vim.keymap.set(
						"n",
						"<leader>gl",
						gs.toggle_current_line_blame,
						{ desc = "Toggle line blame", buffer = bfnr }
					)
					vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk", buffer = bfnr })
				end,
			},
		},
		{
			-- Autoformat
			"stevearc/conform.nvim",
			-- event = "BufWritePre",
			config = function()
				require("conform").setup({
					notify_on_error = false,
					format_on_save = function(bufnr)
						-- Disable with a global or buffer-local variable
						if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
							return
						end
						return { timeout_ms = 1000, lsp_fallback = true }
					end,
					formatters_by_ft = {
						go = { "gofmt" },
						lua = { "stylua" },
						opentofu = { "tofu_fmt" },
						ruby = { "rubocop" },
						rust = { "rustfmt" },
						terraform = { "tofu_fmt" },
						-- Conform can also run multiple formatters sequentially
						-- python = { "isort", "black" },
						--
						-- You can use a sub-list to tell conform to run *until* a formatter
						-- is found.
						-- javascript = { { "prettierd", "prettier" } },
					},
				})

				vim.api.nvim_create_user_command("FormatDisable", function(args)
					if args.bang then
						-- FormatDisable! will disable formatting just for this buffer
						vim.b.disable_autoformat = true
					else
						vim.g.disable_autoformat = true
					end
				end, {
					desc = "Disable autoformat-on-save",
					bang = true,
				})

				vim.api.nvim_create_user_command("FormatEnable", function()
					vim.b.disable_autoformat = false
					vim.g.disable_autoformat = false
				end, {
					desc = "Re-enable autoformat-on-save",
				})

				vim.keymap.set("n", "<leader>lt", function()
					if vim.g.disable_autoformat then
						print("Enabling format on save")
						vim.cmd(":FormatEnable")
					else
						print("Disabling format on save")
						vim.cmd(":FormatDisable")
					end
				end, { desc = "Toggle format on save" })
			end,
		},
	},
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.go", "*.lua" },
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.list = false
		-- vim.opt_local.listchars = { tab = "  ", trail = "·" }
	end,
})
