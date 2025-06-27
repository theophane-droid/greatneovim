-- ============================================================================
-- PACKER.NVIM - Plugin manager
-- ============================================================================
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
    -- Packer itself
    use 'wbthomason/packer.nvim'

    -- File explorer
    use {
        'nvim-tree/nvim-tree.lua',
        requires = { 'nvim-tree/nvim-web-devicons' }, -- file-type icons
        config = function()
            require('nvim-tree').setup {
                view = { width = 30, relativenumber = true },
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
vim.opt.mouse         = ""
vim.opt.conceallevel  = 0
vim.opt.hidden        = true
vim.opt.incsearch     = true
vim.opt.hlsearch      = true
vim.opt.ignorecase    = true
vim.opt.smartcase     = true
vim.opt.timeoutlen    = 500

-- ============================================================================
-- KEYMAPS
-- ============================================================================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Window navigation
vim.keymap.set('n','<C-h>','<C-w>h',{ desc='Left window' })
vim.keymap.set('n','<C-j>','<C-w>j',{ desc='Down window' })
vim.keymap.set('n','<C-k>','<C-w>k',{ desc='Up window' })
vim.keymap.set('n','<C-l>','<C-w>l',{ desc='Right window' })

-- Window resize (Ctrl+Arrows)
vim.keymap.set('n','<C-Up>',   ':resize +2<CR>',           { desc='Increase height' })
vim.keymap.set('n','<C-Down>', ':resize -2<CR>',           { desc='Decrease height' })
vim.keymap.set('n','<C-Left>', ':vertical resize -4<CR>',  { desc='Decrease width' })
vim.keymap.set('n','<C-Right>',':vertical resize +4<CR>',  { desc='Increase width' })

-- Window resize with leader
vim.keymap.set('n','<leader>h',':vertical resize -4<CR>',  { desc='Decrease width' })
vim.keymap.set('n','<leader>l',':vertical resize +4<CR>',  { desc='Increase width' })
vim.keymap.set('n','<leader>k',':resize +2<CR>',           { desc='Increase height' })
vim.keymap.set('n','<leader>j',':resize -2<CR>',           { desc='Decrease height' })

-- Save / quit
vim.keymap.set('n','<leader>w',':w<CR>', { desc='Save' })
vim.keymap.set('n','<leader>q',':q<CR>', { desc='Quit' })
vim.keymap.set('n','<leader>x',':x<CR>', { desc='Save & quit' })

-- Nvim-tree & Telescope
vim.keymap.set('n','<leader>e',':NvimTreeToggle<CR>', { desc='Toggle NvimTree' })
vim.keymap.set('n','<leader>ff',':Telescope find_files<CR>',{ desc='Find files' })
vim.keymap.set('n','<leader>fg',':Telescope live_grep<CR>', { desc='Live grep' })
vim.keymap.set('n','<leader>fb',':Telescope buffers<CR>',   { desc='Buffers' })
vim.keymap.set('n','<leader>fh',':Telescope help_tags<CR>', { desc='Help tags' })

-- ============================================================================
-- PLUGIN CONFIG
-- ============================================================================
require('mason').setup()
require('mason-lspconfig').setup {
    ensure_installed = { "lua_ls","jsonls","yamlls","pyright",
                         "tsserver","html","cssls", "clangd" },
    automatic_installation = true,
}

local cmp = require('cmp')
local luasnip = require('luasnip')
cmp.setup {
    snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
    mapping = cmp.mapping.preset.insert {
        ['<C-b>']   = cmp.mapping.scroll_docs(-4),
        ['<C-f>']   = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>']   = cmp.mapping.abort(),
        ['<CR>']    = cmp.mapping.confirm { select = true },
    },
    sources = {
        { name='nvim_lsp' },
        { name='luasnip' },
        { name='buffer'  },
        { name='path'    },
    },
}
require('luasnip.loaders.from_vscode').lazy_load()

local on_attach = function(_, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n','gd', vim.lsp.buf.definition,     opts)
    vim.keymap.set('n','gD', vim.lsp.buf.declaration,    opts)
    vim.keymap.set('n','gr', vim.lsp.buf.references,     opts)
    vim.keymap.set('n','gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n','K',  vim.lsp.buf.hover,          opts)
    vim.keymap.set('n','<C-k>',vim.lsp.buf.signature_help,opts)
    vim.keymap.set('n','<leader>rn',vim.lsp.buf.rename,  opts)
    vim.keymap.set('n','<leader>ca',vim.lsp.buf.code_action,opts)
    vim.keymap.set('n','[d',vim.diagnostic.goto_prev,    opts)
    vim.keymap.set('n',']d',vim.diagnostic.goto_next,    opts)
    vim.keymap.set('n','<leader>f',
        function() vim.lsp.buf.format { async=true } end, opts)
end

require('lspconfig').lua_ls.setup {
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
        },
    },
}
require('lspconfig').clangd.setup {
    on_attach = on_attach,
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = require('lspconfig.util').root_pattern("compile_commands.json", ".git"),
}

vim.api.nvim_create_user_command("Cheatsheet", function()
    require("cheatsheet").show()
end, { desc = "Show Vim/Neovim Cheatsheet" })

vim.cmd.colorscheme 'dracula'
vim.keymap.set('n','<leader>cs',':Cheatsheet<CR>', { desc='Show Cheatsheet' })
vim.keymap.set('n','<leader>n', ':set invrelativenumber<CR>', { desc='Toggle relativenumber' })
vim.keymap.set('n','<leader>t', ':terminal<CR>', { desc='Open terminal' })
vim.keymap.set('n','<leader>r', ':luafile $MYVIMRC<CR>', { desc='Reload config' })
vim.keymap.set("n", "<leader>g", vim.lsp.buf.references, { noremap = true, silent = true })
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Show diagnostic' })

vim.api.nvim_set_keymap('t','<Esc>','<C-\\><C-n>',{ noremap=true,silent=true })

