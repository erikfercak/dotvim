-- Forgo lazy loading for an experimental loader with byte-compilation cache
vim.loader.enable()

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
vim.opt.history = 100

vim.opt.winborder = "rounded"

-- Reinstall treesitter parsers after nvim-treesitter is updated.
-- Must be registered before vim.pack.add() so the autocmd fires on first install.
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			require("nvim-treesitter").update()
		end
	end,
})

vim.pack.add({
	-- Dependencies first
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/j-hui/fidget.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
	"https://github.com/neovim/nvim-lspconfig",

	-- Colorscheme
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },

	-- Treesitter
	"https://github.com/nvim-treesitter/nvim-treesitter",

	-- Mini
	"https://github.com/echasnovski/mini.nvim",

	-- Telescope
	{ src = "https://github.com/nvim-telescope/telescope.nvim", version = "0.1.8" },
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",

	-- UI / utility
	"https://github.com/folke/which-key.nvim",
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = "v3.x" },
	"https://github.com/nvim-lualine/lualine.nvim",

	-- Mason
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim",

	-- LSP / formatting
	-- "https://github.com/nvimtools/none-ls.nvim",
	"https://github.com/stevearc/conform.nvim",

	-- Editing
	"https://github.com/kylechui/nvim-surround",
	"https://github.com/folke/flash.nvim",

	-- Git
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/lewis6991/gitsigns.nvim",

	-- File explorer
	"https://github.com/stevearc/oil.nvim",
})

-- Colorscheme
vim.cmd.colorscheme("catppuccin-mocha")

local ts_parsers = {
	"bash",
	"elixir",
	"fish",
	"go",
	"html",
	"javascript",
	"lua",
	"markdown",
	"nix",
	"ruby",
	"rust",
	"vim",
	"vimdoc",
	"zig",
}
require("nvim-treesitter").install(ts_parsers)

-- Map parser name -> filetype(s) for autocmds. Most match by name; list overrides.
local ts_filetypes = {
	bash = { "bash", "sh" },
	elixir = { "elixir", "eelixir", "heex" },
	fish = { "fish" },
	go = { "go" },
	html = { "html" },
	javascript = { "javascript", "javascriptreact" },
	lua = { "lua" },
	markdown = { "markdown" },
	ruby = { "ruby" },
	rust = { "rust" },
	vim = { "vim" },
	vimdoc = { "help" },
	zig = { "zig" },
}

local all_filetypes = {}
for _, fts in pairs(ts_filetypes) do
	for _, ft in ipairs(fts) do
		table.insert(all_filetypes, ft)
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = all_filetypes,
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf)
		vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- Mini
require("mini.ai").setup()

-- Telescope
do
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
		extensions = {
			["ui-select"] = {
				require("telescope.themes").get_dropdown({}),
			},
		},
	})
	require("telescope").load_extension("ui-select")

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

	vim.keymap.set("n", "<leader>/", function()
		builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			winblend = 10,
			previewer = false,
		}))
	end, { desc = "[/] Fuzzily search in current buffer" })
end

-- which-key
vim.o.timeout = true
vim.o.timeoutlen = 300
require("which-key").setup()

-- neo-tree
vim.keymap.set("n", "<leader>t", ":Neotree toggle<cr>", { desc = "Neotree" })
vim.keymap.set("n", "<leader>p", ":Neotree reveal<cr>", { desc = "Show current file in Neotree" })

-- lualine
require("lualine").setup({
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
				ignore_lsp = {},
			},
		},
	},
})

-- Mason
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "expert", "lua_ls", "gopls", "ruby_lsp", "rust_analyzer", "zls" },
	automatic_enable = {
		exclude = { "elixirls", "expert" },
	},
})

-- blink.cmp
require("blink.cmp").setup({
	keymap = { preset = "default" },
	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	signature = { enabled = true },
	completion = { documentation = { auto_show = true } },
	fuzzy = { implementation = "prefer_rust_with_warning" },
})

-- LSP
do
	require("fidget").setup({})

	local default_capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())

	-- vim.lsp.config("expert", {
	-- 	cmd = { "/Users/erik/.local/share/nvim/mason/bin/expert", "--stdio" },
	-- 	root_markers = { "mix.exs", ".git" },
	-- 	filetypes = { "elixir", "eelixir", "heex" },
	-- })
	-- vim.lsp.enable("expert")
	--
	--

	vim.lsp.config("dexter", {
		cmd = { "dexter", "lsp" },
		root_markers = { ".dexter.db", ".git", "mix.exs" },
		filetypes = { "elixir", "eelixir", "heex" },
		init_options = {
			followDelegates = true, -- jump through defdelegate to the target function
			-- stdlibPath = "",      -- override Elixir stdlib path (auto-detected)
			-- debug = false,        -- verbose logging to stderr (view with :LspLog)
		},
	})
	vim.lsp.enable("dexter")

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

	vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
	vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

	vim.g.virtual_text_enabled = true
	vim.diagnostic.config({
		virtual_text = vim.g.virtual_text_enabled,
	})

	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(event)
			local gen_opts = function(description)
				return { buffer = event.buf, desc = description }
			end

			vim.keymap.set("n", "gd", vim.lsp.buf.definition, gen_opts("Goto definition"))
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, gen_opts("Goto declaration"))
			vim.keymap.set("n", "K", vim.lsp.buf.hover, gen_opts("LSP hover"))
			vim.keymap.set({ "n", "v" }, "<space>la", vim.lsp.buf.code_action, gen_opts("Code actions"))
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
end

-- nvim-surround
require("nvim-surround").setup({})

-- gitsigns
require("gitsigns").setup({
	current_line_blame_opts = {
		delay = 100,
	},
	on_attach = function(bfnr)
		local gs = package.loaded.gitsigns

		vim.keymap.set("n", "<leader>gl", gs.toggle_current_line_blame, { desc = "Toggle line blame", buffer = bfnr })
		vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk", buffer = bfnr })
	end,
})

-- conform
do
	require("conform").setup({
		notify_on_error = false,
		format_on_save = function(bufnr)
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
		},
	})

	vim.api.nvim_create_user_command("FormatDisable", function(args)
		if args.bang then
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
end

-- oil
require("oil").setup({})

-- flash
require("flash").setup({ modes = { char = { enabled = false } } })
vim.keymap.set({ "n", "x", "o" }, "<leader>s", function()
	require("flash").jump()
end, { desc = "Flash Jump" })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*.go", "*.lua" },
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.list = false
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
