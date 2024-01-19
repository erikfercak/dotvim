vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

vim.opt.hidden = true
-- vim.opt.signcolumn = "yes:1"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.termguicolors = true
vim.opt.spell = false
vim.opt.title = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

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
      "ishan9299/nvim-solarized-lua",
      priority = 1000,
      config = function()
        vim.cmd.colorscheme("solarized")
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
          ensure_installed = {
            "html",
            "javascript",
            "lua",
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
        vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "find buffers" })
        vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "find files" })
        vim.keymap.set("n", "<leader>r", builtin.oldfiles, { desc = "find recent files" })
        vim.keymap.set("n", "<leader>g", builtin.live_grep, { desc = "live grep" })
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
          lualine_c = { { 'filename', path = 1 } }
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
        ensure_installed = { "lua_ls" }
      }
    },
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "folke/neodev.nvim"
      },
      config = function()
        local lspconfig = require("lspconfig")

        lspconfig.lua_ls.setup({
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT'
              },
              diagnostics = {
                globals = {'vim'},
              },
              workspace = {
                library = {
                  vim.env.VIMRUNTIME,
                }
              }
            }
          }
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
          virtual_text = vim.g.virtual_text_enabled
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
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, gen_opts("Goto declaration"))
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, gen_opts("Goto definition"))
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

        cmp.setup({
          sources = {
            {name = "nvim_lsp"},
          },
          mapping = cmp.mapping.preset.insert({
            -- Enter key confirms completion item
            -- Accept currently selected item. Set `select` to `false`
            -- to only confirm explicitly selected items.
            ["<CR>"] = cmp.mapping.confirm({select = true}),

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
      opts = {
        -- add any options here
      },
      lazy = false,
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
  },
})
