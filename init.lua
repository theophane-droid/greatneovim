-- ============================================================================
-- PACKER.NVIM - Plugin manager
-- ============================================================================
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
    -- Packer itself
    use 'wbthomason/packer.nvim'

    -- show marks 
    use 'kshenoy/vim-signature'

    -- File explorer
    use {
      'nvim-tree/nvim-tree.lua',
      requires = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        local tree = require("nvim-tree")
        local api  = require("nvim-tree.api")

        tree.setup {
          view     = { width = 50, relativenumber = true },
          renderer = { group_empty = true },
          filters  = { dotfiles = true },
        }

      end
    }
    -- Status line
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true },
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    theme = 'auto',
                    component_separators = { left = '', right = '' },
                    section_separators   = { left = '', right = '' },
                    always_last_status = true,
                    padding = { left = 1, right = 1 },
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = { 'filename' },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' },
                },
                inactive_sections = {
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                },
            }
        end
    }
    -- hardtime for nvim command help
    use {
      "m4xshen/hardtime.nvim",
      requires = { "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" },
      config = function()
        require("hardtime").setup()
      end
    }
    -- Completion
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'
    use 'rafamadriz/friendly-snippets'

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'

    -- Syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = {
                    "c","cpp","lua","vim","vimdoc","query","json","yaml",
                    "markdown","python","javascript","typescript","html","css"
                },
                highlight = { enable = true },
                indent    = { enable = true },
            }
        end
    }

    -- Fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.x',
        requires = { 'nvim-lua/plenary.nvim' },
    }

    -- Icons
    use 'kyazdani42/nvim-web-devicons'

    -- Theme
    use 'dracula/vim'

    -- Welcome screen
    use {
      'goolord/alpha-nvim',
        config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
          " ",
          "      ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
          "      ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
          "      ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
          "      ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
          "      ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
          "      ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
          " ",
          "                  ✨ Hello, beauty! ✨",
          "     What amazing project will you start today?",
          " ",
          "       GitHub: https://github.com/theophane-droid",
          "       OSS117 quotes: https://oss117quotes.xyz/",
          " ",
        }

        dashboard.section.buttons.val = {
          dashboard.button("space cs", "  Open Cheatsheet", ":Cheatsheet<CR>"),
          dashboard.button("space ff", "  Find File", ":Telescope find_files<CR>"),
          dashboard.button("space fg", "󰱼  Live Grep", ":Telescope live_grep<CR>"),
          dashboard.button("q",      "  Quit", ":qa<CR>"),
        }

        alpha.setup(dashboard.config)
      end
    }

end)

-- ============================================================================
-- BASIC OPTIONS
-- ============================================================================
vim.opt.nu            = true
vim.opt.rnu           = true
vim.opt.tabstop       = 4
vim.opt.shiftwidth    = 4
vim.opt.expandtab     = true
vim.opt.autoindent    = true
vim.opt.smartindent   = true
vim.opt.wrap          = false
vim.opt.encoding      = "utf-8"
vim.opt.fileencoding  = "utf-8"
vim.opt.scrolloff     = 8
vim.opt.sidescrolloff = 8
vim.opt.termguicolors = true
vim.opt.mouse         = "a"
vim.opt.conceallevel  = 0
vim.opt.hidden        = true
vim.opt.incsearch     = true
vim.opt.hlsearch      = true
vim.opt.ignorecase    = true
vim.opt.smartcase     = true
vim.opt.timeoutlen    = 500


-- ============================================================================
-- Keymaps add
-- ============================================================================
require('keymaps')


-- ============================================================================
-- Config edit shortcut 
-- ============================================================================
vim.api.nvim_create_user_command('Conf', function()
  vim.cmd('edit ~/.config/nvim')
end, {})

vim.api.nvim_create_user_command('Config', function()
  vim.cmd('edit ~/.config/nvim')
end, {})
