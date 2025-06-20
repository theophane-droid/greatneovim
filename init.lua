-- ============================================================================
-- PACKER.NVIM - Gestionnaire de plugins
-- ============================================================================
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
    -- Packer lui-même
    use 'wbthomason/packer.nvim'

    -- Gestion de fichiers
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- Nécessaire pour les icônes de fichiers
        },
        config = function()
            require('nvim-tree').setup {
                view = {
                    width = 30,
                    relativenumber = true, -- Numéros de ligne relatifs dans nvim-tree
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = true,
                },
            }
        end
    }

    -- Barre de statut
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true },
        config = function()
            require('lualine').setup({
                options = {
                    icons_enabled = true,
                    theme = 'auto', -- Ou 'dracula', 'gruvbox', 'solarized', etc.
                    component_separators = { left = '', right = ''},
                    section_separators = { left = '', right = ''},
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_last_status = true,
                    padding = { left = 1, right = 1 },
                },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff', 'diagnostics'},
                    lualine_c = {'filename'},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {'progress'},
                    lualine_z = {'location'}
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {'filename'},
                    lualine_x = {'location'},
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {},
                extensions = {}
            })
        end
    }

    -- Complétion
    use 'hrsh7th/nvim-cmp'             -- Moteur de complétion
    use 'hrsh7th/cmp-nvim-lsp'         -- Source pour LSP
    use 'hrsh7th/cmp-buffer'           -- Source pour les buffers ouverts
    use 'hrsh7th/cmp-path'             -- Source pour les chemins de fichiers
    use 'hrsh7th/cmp-cmdline'          -- Source pour la ligne de commande
    use 'saadparwaiz1/cmp_luasnip'     -- Source pour snippet (si vous utilisez luasnip)
    use 'L3MON4D3/LuaSnip'             -- Moteur de snippets (optionnel, mais recommandé)
    use 'rafamadriz/friendly-snippets' -- Snippets amicaux (optionnel)

    -- LSP (Language Server Protocol)
    use 'neovim/nvim-lspconfig'        -- Configuration des serveurs LSP
    use 'williamboman/mason.nvim'      -- Gestionnaire de serveurs LSP
    use 'williamboman/mason-lspconfig.nvim' -- Intégration de Mason avec nvim-lspconfig

    -- Syntax Highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            pcall(require('nvim-treesitter.install').update({ with_sync = true }))
        end,
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "json", "yaml", "markdown", "python", "javascript", "typescript", "html", "css" }, -- Installez les langages dont vous avez besoin
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
            })
        end
    }

    -- Fuzzy Finder
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- Icônes pour Nvim-tree et Lualine
    use 'kyazdani42/nvim-web-devicons'

    -- Thème (exemple)
    use 'dracula/vim' -- Ou 'folke/tokyonight.nvim', 'catppuccin/nvim', etc.

end)

-- ============================================================================
-- OPTIONS DE BASE DE NEOVIM
-- ============================================================================

-- Afficher les numéros de ligne
vim.opt.nu = true
vim.opt.rnu = true -- Numéros de ligne relatifs (très utile pour les mouvements)

-- Indentation
vim.opt.tabstop = 4         -- Nombre d'espaces qu'une tabulation représente
vim.opt.shiftwidth = 4      -- Nombre d'espaces pour une indentation
vim.opt.expandtab = true    -- Utilise des espaces au lieu de tabulations
vim.opt.autoindent = true   -- Conserve l'indentation de la ligne précédente
vim.opt.smartindent = true  -- Indentation "intelligente" pour certains langages

-- Autres options utiles
vim.opt.wrap = false        -- Ne pas envelopper les lignes (pas de retour à la ligne automatique)
vim.opt.encoding = "utf-8"  -- Encodage des caractères
vim.opt.fileencoding = "utf-8"
vim.opt.scrolloff = 8       -- Garde 8 lignes au-dessus et en dessous du curseur
vim.opt.sidescrolloff = 8   -- Idem pour le défilement horizontal
vim.opt.termguicolors = true -- Active les couleurs du terminal pour les thèmes GUI
vim.opt.mouse = ""          -- Désactive la souris
vim.opt.conceallevel = 0    -- Affiche les caractères cachés (pour markdown, etc.)
vim.opt.hidden = true       -- Permet de changer de buffer sans enregistrer

-- Recherche
vim.opt.incsearch = true    -- Affiche les résultats de recherche au fur et à mesure
vim.opt.hlsearch = true     -- Met en surbrillance tous les résultats de recherche
vim.opt.ignorecase = true   -- Ignore la casse dans la recherche
vim.opt.smartcase = true    -- N'ignore pas la casse si la recherche contient des majuscules

-- Temps entre les frappes pour les mappings
vim.opt.timeoutlen = 500

-- ============================================================================
-- MAPPINGS / RACCOURCIS CLAVIER
-- ============================================================================

-- Définir la touche "leader" (par défaut c'est '\', je préfère l'espace)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Navigation entre les fenêtres (splits) avec Ctrl + h/j/k/l
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to down window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to up window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

-- Redimensionnement des fenêtres (pour les splits) avec Ctrl + flèches
vim.keymap.set('n', '<C-Up>',    ':resize +2<CR>',        { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>',  ':resize -2<CR>',        { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>',  ':vertical resize -4<CR>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', ':vertical resize +4<CR>', { desc = 'Increase window width' })

-- Redimensionnement des fenêtres avec <Leader>H/J/K/L
vim.keymap.set('n', '<leader>h', ':vertical resize -4<CR>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<leader>l', ':vertical resize +4<CR>', { desc = 'Increase window width' })
vim.keymap.set('n', '<leader>k', ':resize +2<CR>',           { desc = 'Increase window height' })
vim.keymap.set('n', '<leader>j', ':resize -2<CR>',           { desc = 'Decrease window height' })

-- Raccourcis pour enregistrer et quitter
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit Neovim' })
vim.keymap.set('n', '<leader>x', ':x<CR>', { desc = 'Save and Quit Neovim' })

-- Nvim-tree toggle
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle NvimTree' })

-- Telescope (Fuzzy Finder)
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>',  { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>',    { desc = 'List buffers' })
vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>',  { desc = 'Find help tags' })

-- ============================================================================
-- CONFIGURATION DES PLUGINS
-- ============================================================================

-- LSP Configuration avec Mason et Nvim-lspconfig
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "jsonls", "yamlls", "pyright", "tsserver", "html", "cssls" }, -- Installez les serveurs LSP pour les langages que vous utilisez
    automatic_installation = true,
})

-- Configuration nvim-cmp
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body) -- Pour LuaSnip
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>']   = cmp.mapping.scroll_docs(-4),
        ['<C-f>']   = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>']   = cmp.mapping.abort(),
        ['<CR>']    = cmp.mapping.confirm({ select = true }), -- Accepte la sélection actuelle.
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- Snippets
        { name = 'buffer' },  -- Buffers ouverts
        { name = 'path' },    -- Chemins de fichiers
    }
})

-- Configuration de LuaSnip (si vous l'utilisez)
require('luasnip.loaders.from_vscode').lazy_load()

-- Configurer les LSP pour qu'ils soient attachés aux buffers
local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gd',         vim.lsp.buf.definition,     bufopts)
    vim.keymap.set('n', 'gD',         vim.lsp.buf.declaration,    bufopts)
    vim.keymap.set('n', 'gr',         vim.lsp.buf.references,     bufopts)
    vim.keymap.set('n', 'gi',         vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'K',          vim.lsp.buf.hover,          bufopts)
    vim.keymap.set('n', '<C-k>',      vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,         bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,    bufopts)
    vim.keymap.set('n', '[d',         vim.diagnostic.goto_prev,   bufopts)
    vim.keymap.set('n', ']d',         vim.diagnostic.goto_next,   bufopts)
    vim.keymap.set('n', '<leader>f',  function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lspconfig = require('lspconfig')

lspconfig.lua_ls.setup {
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
}

-- Appliquer un thème (ex: Dracula)
vim.cmd('colorscheme dracula')

-- ============================================================================
-- CHEATSHEET INTÉGRÉE
-- ============================================================================
vim.api.nvim_create_user_command('Cheatsheet', function()
    local cheatsheet_content = {
        " --- CHEATSHEET VIM / NEOVIM --- ",
        " ",
        " --- NAVIGATION --- ",
        " h, j, k, l        : Gauche, Bas, Haut, Droite",
        " w, b, e           : Déplacer par mots (début/fin)",
        " 0, ^, $           : Début de ligne (avec espaces), début (sans), fin",
        " gg, G             : Début, Fin du fichier",
        " f<char>, t<char>  : Trouver un caractère (avant/après)",
        " Ctrl+o, Ctrl+i    : Aller à la position précédente/suivante",
        " ",
        " --- MODIFICATION --- ",
        " i, a, o, O        : Insérer (avant/après curseur, nouvelle ligne)",
        " x                 : Supprimer caractère sous curseur",
        " dw, dd, D         : Supprimer mot, ligne, fin de ligne",
        " c<motion>, cc     : Modifier avec mouvement, modifier ligne",
        " s                 : Substituer caractère (supprime et passe en mode insert)",
        " r<char>           : Remplacer un caractère",
        " yy, yw, y<motion> : Copier ligne, mot, avec mouvement",
        " p, P              : Coller (après/avant curseur)",
        " u, Ctrl+r         : Annuler, Rétablir",
        " .                 : Répéter la dernière commande",
        " ",
        " --- MODES SPECIFIQUES --- ",
        " v, V, Ctrl+v      : Sélection visuelle (caractère, ligne, bloc)",
        " :                 : Mode commande (Ex mode)",
        " ",
        " --- COMMANDES EX (Mode ':') --- ",
        " :w                : Sauver",
        " :q                : Quitter",
        " :wq, :x           : Sauver et Quitter",
        " :e <fichier>      : Ouvrir un fichier",
        " :sp, :vs          : Split horizontal, vertical",
        " /pattern          : Chercher (n/N pour suivant/précédent)",
        " :%s/old/new/g     : Remplacer toutes les occurrences",
        " :help <sujet>     : Aide pour un sujet (ex: :help motion)",
        " ",
        " --- PLUGINS ET RACCOURCIS (personnalisés) --- ",
        " <Leader>w         : Sauver le fichier",
        " <Leader>q         : Quitter Neovim",
        " <Leader>x         : Sauver et Quitter",
        " <Leader>e         : Basculer NvimTree (explorateur de fichiers)",
        " <Leader>ff        : Rechercher des fichiers (Telescope)",
        " <Leader>fg        : Rechercher du texte dans les fichiers (Live Grep)",
        " <Leader>fb        : Liste des buffers ouverts",
        " gd                : Aller à la définition LSP",
        " gr                : Aller aux références LSP",
        " K                 : Hover (infos LSP)",
        " <Leader>rn        : Renommer avec LSP",
        " <Leader>ca        : Action de code LSP",
        " [d, ]d            : Naviguer dans les diagnostics (erreurs/warnings)",
        " <Leader>f         : Formater le document (LSP)",
        " ",
        " --- NAVIGATION FENETRES --- ",
        " Ctrl+h/j/k/l      : Naviguer entre les fenêtres",
        " Ctrl+Up/Down/Left/Right : Redimensionner les fenêtres",
        " <Leader>h         : Réduire la largeur",
        " <Leader>l         : Augmenter la largeur",
        " <Leader>k         : Augmenter la hauteur",
        " <Leader>j         : Réduire la hauteur",
        " ",
        " --- LSP (Language Server Protocol) --- ",
        " Pour que la complétion et les fonctionnalités LSP fonctionnent, ",
        " assurez-vous que les serveurs sont installés via Mason (:Mason).",
        " ",
        " --- MACROS --- ",
        " q<register>       : Enregistrer une macro (ex: qa)",
        " @<register>       : Exécuter une macro (ex: @a)",
        " <nombre>@<register>: Exécuter une macro plusieurs fois (ex: 5@a)",
        " ",
        " Pour fermer cette fenêtre, utilisez :q ",
    }
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, cheatsheet_content)

    vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        row = 5,
        col = 5,
        width  = 80,
        height = #cheatsheet_content + 2,
        border = 'single',
        style   = 'minimal',
    })

    vim.bo[buf].filetype = 'markdown'
    vim.bo[buf].modifiable = false
end, { desc = 'Show Vim/Neovim Cheatsheet' })

vim.keymap.set('n', '<leader>cs', ':Cheatsheet<CR>', { desc = 'Show Cheatsheet' })
vim.keymap.set('n', '<leader>n', ':set invrelativenumber<CR>', { desc = 'Toggle relative number'})
vim.keymap.set('n', '<leader>t', ':terminal<CR>', { desc = 'Create terminal'})
vim.keymap.set('n', '<leader>r', ':luafile $MYVcheatsheet_contentIMRC<CR>', { desc = 'Reload conf'})
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

vim.opt.termguicolors = true

