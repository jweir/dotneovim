-- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua

vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'Townk/vim-autoclose',
  'fatih/vim-go',
  'godlygeek/tabular',
  'neovim/nvim-lspconfig',
  'scrooloose/nerdcommenter',
  'scrooloose/nerdtree',
  'tpope/vim-abolish',
  'tpope/vim-endwise',
  'tpope/vim-fugitive',
  'tpope/vim-haml',
  'tpope/vim-rails',
  'tpope/vim-surround',
  'tpope/vim-unimpaired',
  'vim-ruby/vim-ruby',
  {
    'junegunn/fzf',
    build = './install --all',
    dir = '~/.fzf'
  },
  {'junegunn/fzf.vim',
    config = function()
      vim.g.fzf_vim = {
        preview_window = {}
      }
      vim.keymap.set('n', '<leader>fa', ':Ag!', { desc = 'FZF Find Files' })
      vim.keymap.set('n', '<leader>ff', '<cmd>Files!<CR>', { desc = 'FZF Find Files' })
    end
  },
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',
  {
    "zenbones-theme/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
     --you can set set configuration options here
    config = function()
      vim.g.zenbones_darken_comments = 45
      vim.g.zenbones_darkness = 'stark'
      vim.cmd.colorscheme('zenbones')
      vim.opt.termguicolors = true
      vim.opt.background= 'dark'
    end
}
})

vim.opt.mouse = 'a'
vim.opt.mousefocus = true
vim.opt.mousehide = true

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.opt.directory= '/tmp/' -- Set temporary directory (don't litter local dir with swp/tmp files)
vim.opt.swapfile = false   -- No swap files when editing please
vim.opt.wrap     = false   -- Disable line wrapping
vim.opt.confirm = true

-- " use indents of 2 spaces, and have them copied down lines:
vim.opt.expandtab = true
vim.opt.tabstop=2
vim.opt.softtabstop=2
vim.opt.shiftwidth=2
vim.opt.number = false -- no line numbers

-- " Keybindings
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- clear search
vim.keymap.set('n', '<leader>rr', ':NERDTreeFind<CR>')
vim.keymap.set('n', 'tp', ':tabprevious<CR>')
vim.keymap.set('n', 'tn', ':tabnext<CR>')
vim.keymap.set('n', 'tN', ':tabnew<CR>')
vim.keymap.set('n', '<Leader>s', ':%s/\\<<C-r><C-w>\\>/', { noremap = true })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- LSPs
lsp = require('lspconfig')

local capabilities = require('cmp_nvim_lsp').default_capabilities()
lsp.cssls.setup { capabilities = capabilities}
lsp.elmls.setup { capabilities = capabilities}
lsp.rubocop.setup { capabilities = capabilities}
lsp.sorbet.setup {
  cmd = {
    'ssh',
    'deploy@dev.pharosams.com',
    'srb',
    'tc',
    '--lsp',
    '--enable-all-experimental-lsp-features',
    '--enable-experimental-requires-ancestor',
    '/data/pharos/ams/current'
  },
  capabilities = capabilities
}

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
-- https://neovim.io/doc/user/lsp.html
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)

    -- autoformat on save with the below
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

    if not client:supports_method('textDocument/willSaveWaitUntil')
      and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', {clear=false}),
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})


-- Set up nvim-cmp.
-- https://github.com/hrsh7th/nvim-cmp
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- in the docs windo
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})
