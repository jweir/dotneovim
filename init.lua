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
  {
    'ggml-org/llama.vim',
    init = function()
      vim.g.llama_config = {
        show_info = 0,
        keymap_accept_full = "<Space><Space>",
        keymap_accept_line = "<S-Space>",
      }
    end
  },
  'godlygeek/tabular',
  'neovim/nvim-lspconfig',
  'scrooloose/nerdcommenter',
  'scrooloose/nerdtree',
  'tpope/vim-abolish',
  'tpope/vim-endwise',
  'tpope/vim-fugitive',
  'tpope/vim-git',
  'tpope/vim-haml',
  'tpope/vim-rails',
  'tpope/vim-surround',
  'tpope/vim-unimpaired',
  'vim-ruby/vim-ruby',
  'rktjmp/lush.nvim',
  {
    'junegunn/fzf',
    build = './install --all',
    dir = '~/.fzf'
  },
  {
    'junegunn/fzf.vim',
    config = function()
      vim.g.fzf_vim = {
        preview_window = {}
      }
      vim.keymap.set('n', '<leader>fa', ':Ag!', { desc = 'FZF search files' })
      vim.keymap.set('n', '<leader>ff', '<cmd>Files!<CR>', { desc = 'FZF Find Files' })
    end
  },
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',
  { 'rktjmp/lush.nvim',
    { dir = '/Users/johnweir/src/github.com/jweir/trumono', lazy = false },
  },
})

vim.cmd.colorscheme('trumono')
vim.opt.mouse = 'a'
vim.opt.mousefocus = true
vim.opt.mousehide = true

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)


vim.opt.directory   = '/tmp/' -- Set temporary directory (don't litter local dir with swp/tmp files)
vim.opt.swapfile    = false   -- No swap files when editing please
vim.opt.wrap        = false   -- Disable line wrapping
vim.opt.confirm     = true

-- " use indents of 2 spaces, and have them copied down lines:
vim.opt.expandtab   = true
vim.opt.tabstop     = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth  = 2
vim.opt.number      = false -- no line numbers

local function toggleScheme()
  if vim.o.background == "light" then
    vim.o.background = "dark"
    vim.cmd("colorscheme trumono")
  else
    vim.o.background = "light"
    vim.cmd("colorscheme quiet")
  end
end
-- " Keybindings
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>') -- clear search
vim.keymap.set('n', '<leader>rr', ':NERDTreeFind<CR>')
vim.keymap.set('n', 'tp', ':tabprevious<CR>')
vim.keymap.set('n', 'tn', ':tabnext<CR>')
vim.keymap.set('n', 'tN', ':tabnew<CR>')
vim.keymap.set('n', '<Leader>s', ':%s/\\<<C-r><C-w>\\>/', { noremap = true })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>b', toggleScheme)

-- LSPs
local lsp = require('lspconfig')

-- Function to determine the correct command based on current directory
local function get_sorbet_cmd()
  local cwd = vim.fn.getcwd()

  -- Check if we're in a specific directory
  if string.match(cwd, "pharos") or string.match(cwd, "ams") then
    -- Remote sorbet setup for the pharos project
    return {
      'ssh',
      'deploy@dev.pharosams.com',
      'srb',
      'tc',
      '--lsp',
      '--enable-all-experimental-lsp-features',
      '--enable-experimental-requires-ancestor',
      '/data/pharos/ams/current'
    }
  else
    -- Default local sorbet setup
    return {
      'srb',
      'tc',
      '--lsp',
      '--enable-all-experimental-lsp-features'
    }
  end
end

local t = { 1, 2, 3, 4 }

local capabilities = require('cmp_nvim_lsp').default_capabilities()
lsp.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  }
}
lsp.cssls.setup { capabilities = capabilities }
lsp.elmls.setup { capabilities = capabilities }
lsp.gopls.setup { capabilities = capabilities }
lsp.rubocop.setup { capabilities = capabilities }
lsp.ts_ls.setup { capabilities = capabilities } -- typescript / javascript
lsp.sorbet.setup {
  cmd = get_sorbet_cmd(),
  capabilities = capabilities,
  init_options = {
    highlightUntyped = "everywhere-but-tests"
  }
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
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
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
--
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local cmp = require 'cmp'
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
