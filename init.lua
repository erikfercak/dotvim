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
vim.opt.virtualedit = "block"

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
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.opt.wildmode = "longest:full,full"
vim.opt.wrap = false
vim.opt.listchars = { tab = "»·", trail = "·", nbsp = "␣" }
vim.opt.list = true
vim.opt.mouse = ""
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

vim.opt.winborder = "rounded"

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
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				local configs = require("nvim-treesitter.configs")

				configs.setup({
					ensure_installed = {
						"bash",
						"elixir",
						"fish",
						"go",
						"html",
						"javascript",
						"lua",
						"markdown",
						"ruby",
						"rust",
						"vim",
						"vimdoc",
						"zig",
					},
					sync_install = false,
					auto_install = true,
					highlight = { enable = true },
					indent = { enable = true },
				})
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			config = function()
				require("treesitter-context").setup({
					enable = false,
				})
				vim.keymap.set("n", "<leader>c", "<cmd>TSContext toggle<CR>", { desc = "toggle context" })
			end,
		},
		{
			"echasnovski/mini.nvim",
			version = "*",
			config = function()
				require("mini.ai").setup()
			end,
		},
		{
			"nvim-telescope/telescope.nvim",
			event = "VeryLazy",
			tag = "0.1.8",
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
					pickers = {
						buffers = {
							mappings = {
								i = {
									["<c-d>"] = actions.delete_buffer,
								},
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
				vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "git status files" })

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
				vim.keymap.set("n", "<leader>p", ":Neotree reveal<cr>", { desc = "Show current file in Neotree" })
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
					lualine_z = {
						"location",
						{
							"lsp_status",
							ignore_lsp = { "null-ls" },
						},
					},
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
				ensure_installed = { "expert", "lua_ls", "gopls", "ruby_lsp", "rust_analyzer", "zls" },
			},
		},
		{
			"saghen/blink.cmp",
			-- optional: provides snippets for the snippet source
			dependencies = "rafamadriz/friendly-snippets",

			-- use a release tag to download pre-built binaries
			version = "1.*",
			-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
			-- build = 'cargo build --release',
			-- If you use nix, you can build from source using latest nightly rust with:
			-- build = 'nix run .#build-plugin',

			---@module 'blink.cmp'
			---@type blink.cmp.Config
			opts = {
				-- 'default' for mappings similar to built-in completion
				-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
				-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
				-- see the "default configuration" section below for full documentation on how to define
				-- your own keymap.
				keymap = { preset = "default" },

				appearance = {
					-- Sets the fallback highlight groups to nvim-cmp's highlight groups
					-- Useful for when your theme doesn't support blink.cmp
					-- will be removed in a future release
					use_nvim_cmp_as_default = true,
					-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
					-- Adjusts spacing to ensure icons are aligned
					nerd_font_variant = "mono",
				},

				-- default list of enabled providers defined so that you can extend it
				-- elsewhere in your config, without redefining it, via `opts_extend`
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
					-- optionally disable cmdline completions
					-- cmdline = {},
				},

				-- experimental signature help support
				signature = { enabled = true },

				completion = { documentation = { auto_show = true } },
				fuzzy = { implementation = "prefer_rust_with_warning" },
			},
			-- allows extending the providers array elsewhere in your config
			-- without having to redefine it
			opts_extend = { "sources.default" },
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"saghen/blink.cmp",
				-- "folke/neodev.nvim",
				"j-hui/fidget.nvim",
			},
			config = function()
				-- require("neodev").setup({})
				require("fidget").setup({})

				local default_capabilities =
					require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

				-- vim.lsp.config("elixirls", {
				-- 	cmd = { "/Users/erik/.local/share/nvim/mason/bin/elixir-ls" },
				-- 	capabilities = default_capabilities,
				-- })
				--
				vim.lsp.config("expert", {
					-- cmd = { "/Users/erik/bin/expert-ls" },
					cmd = { "/Users/erik/.local/share/nvim/mason/bin/expert", "--stdio" },
					root_markers = { "mix.exs", ".git" },
					filetypes = { "elixir", "eelixir", "heex" },
				})
				vim.lsp.enable("expert")

				vim.lsp.config("nu", {
					cmd = { "nu", "--lsp" },
					filetypes = { "nu" },
					single_file_support = true,
				})
				vim.lsp.enable("nu")

				vim.lsp.config("zls", {
					capabilities = default_capabilities,
				})

				vim.lsp.config("ruby_lsp", {
					capabilities = default_capabilities,
				})

				vim.lsp.config("rust_analyzer", {
					capabilities = default_capabilities,
				})

				vim.lsp.config("gopls", {
					capabilities = default_capabilities,
				})

				vim.lsp.config("lua_ls", {
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
				-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
				-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
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
						-- vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

						-- Buffer local mappings.
						-- See `:help vim.lsp.*` for documentation on any of the below functions
						vim.keymap.set("n", "gd", vim.lsp.buf.definition, gen_opts("Goto definition"))
						vim.keymap.set("n", "gD", vim.lsp.buf.declaration, gen_opts("Goto declaration"))
						vim.keymap.set("n", "K", vim.lsp.buf.hover, gen_opts("LSP hover"))
						-- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, gen_opts("Goto implementation"))
						-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
						-- vim.keymap.set('n', '<12space>wa', vim.lsp.buf.add_workspace_folder, opts)
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

						local client = vim.lsp.get_client_by_id(event.data.client_id)
						if client and client.server_capabilities.documentHighlightProvider then
							vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
								buffer = event.buf,
								callback = vim.lsp.buf.document_highlight,
							})

							vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
								buffer = event.buf,
								callback = vim.lsp.buf.clear_references,
							})
						end
					end,
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
						return { timeout_ms = 1000, lsp_format = "fallback" }
					end,
					formatters_by_ft = {
						elixir = { "mix" },
						go = { "gofmt" },
						lua = { "stylua" },
						opentofu = { "tofu_fmt" },
						ruby = { "standardrb" },
						rust = { "rustfmt" },
						terraform = { "tofu_fmt" },
						-- Conform can also run multiple formatters sequentially
						-- python = { "isort", "black" },
						--
						-- You can tell conform to run *until* a formatter is found.
						-- javascript = { "prettierd", "prettier", stop_after_first = true },
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
		{
			"stevearc/oil.nvim",
			opts = {},
			-- Optional dependencies
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
		{
			"folke/flash.nvim",
			event = "VeryLazy",
			opts = { modes = { char = { enabled = false } } },
			keys = {
				{
					"<leader>s",
					mode = { "n", "x", "o" },
					function()
						require("flash").jump()
					end,
					desc = "Flash Jump",
				},
			},
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

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client then
			if client:supports_method("textDocument/completion") then
				vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
			end
		end
	end,
})
