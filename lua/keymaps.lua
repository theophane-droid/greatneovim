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
vim.keymap.set('n', '<leader>e', function()
    vim.cmd('NvimTreeToggle')
end, { desc = 'Toggle NvimTree with resize' })

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
vim.keymap.set('n', "<leader>g", vim.lsp.buf.references, { noremap = true, silent = true })
vim.keymap.set('n', "<leader>ns", ':noh<CR>', { desc='Cancel search',  silent = true })
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Show diagnostic' })

-- Copy-paste shortcuts
vim.keymap.set('v', "y", '"+y', opts)
vim.keymap.set("n", "p", '"+p', opts)
vim.keymap.set("n", "P", '"+P', opts)
vim.keymap.set({ "v" }, "d", '"+d')
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "dd", '"+dd', opts)
vim.keymap.set("n", "yy", '"+yy', opts)

vim.keymap.set("i", "<C-v>", '<C-r>+', opts)

vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- No lines numbers
vim.keymap.set("n", "<leader>ln", function()
  if vim.wo.number then
    vim.wo.number = false
    vim.wo.relativenumber = false
  else
    vim.wo.number = true
    vim.wo.relativenumber = true
  end
end, { desc = "Toggle line numbers" })


-- Escape term
vim.api.nvim_set_keymap('t','<Esc>','<C-\\><C-n>',{ noremap=true,silent=true })

-- Ctrl + l to center the cursor
vim.keymap.set("n", "<C-l>", "zz", { noremap = true, silent = true })

-- Center the cursor before scroll
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })



-- Add conf opening shortcut
vim.api.nvim_create_user_command('Conf', function()
  vim.cmd('edit ~/.config/nvim')
end, {})

vim.api.nvim_create_user_command('Config', function()
  vim.cmd('edit ~/.config/nvim')
end, {})

vim.keymap.set('n','<leader>!',':Hardtime toggle<CR>', { desc='Toggle hardtime' })
