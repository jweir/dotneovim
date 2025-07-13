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
  'tpope/vim-rhubarb',
  'vim-ruby/vim-ruby',
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
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
  {
    -- https://cmp.saghen.dev/
    'saghen/blink.cmp',

    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets' },
    opts = {
      signature = { enabled = true },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },
      keymap = {
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },

        ['<cr>'] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          'snippet_forward',
          'fallback'
        },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },
      sources = {
        default = function(ctx)
          local success, node = pcall(vim.treesitter.get_node)
          if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
            return { 'buffer' }
          elseif vim.bo.filetype == 'lua' then
            return { 'lsp', 'path' }
          elseif vim.bo.filetype == 'elm' then
            return { 'lsp' }
          else
            return { 'lsp', 'path', 'snippets', 'buffer' }
          end
        end
      },
      fuzzy = { implementation = "lua" }
    },
    opts_extend = { "sources.default" }
  },
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

local function openAmsTestFailuresQuickFix()
  vim.cmd.cfile(os.getenv("PHAROSPATH") .. "/.failed_tests.txt")
  vim.cmd.copen()
end

-- open AMS failed tests in quickfix
vim.keymap.set('n', '<leader>tq', openAmsTestFailuresQuickFix, { desc = 'open failed tests in quickfix (ams test)' })

-- disable side scrolling
vim.keymap.set('n', '<ScrollWheelRight>', '<nop>')
vim.keymap.set('n', '<ScrollWheelLeft>', '<nop>')

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

local function setDiagnostics(severity)
  vim.diagnostic.config({
    virtual_text = false, --{ severity = { min = severity, }, },
    float = { severity = { min = severity, }, },
    signs = { severity = { min = severity, }, },
    underline = { severity = { min = severity, }, },
  })
end

local function setDiagnosticsWarning()
  setDiagnostics(vim.diagnostic.severity.WARN)
end

local function setDiagnosticsInfo()
  setDiagnostics(vim.diagnostic.severity.INFO)
end

setDiagnostics(vim.diagnostic.severity.WARN)

--vim.keymap.set('n', '<leader>di', setDiagnosticsInfo)
--vim.keymap.set('n', '<leader>dw', setDiagnosticsWarning)



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

local capabilities = {
  textDocument = {
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
    }
  }
}

capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

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


local culsp_group = vim.api.nvim_create_augroup("CulspSettings", { clear = true })
--vim.api.nvim_create_autocmd({ "FileType" }, {
--pattern = "text",
--group = culsp_group,
--callback = function()
--vim.lsp.start({
--cmd = { "culsp" },
--filetypes = { 'text' },
--root_dir = vim.fn.getcwd(), -- Use PWD as project root dir.
--})
--end
--})

--vim.lsp.start({
--cmd = { "culsp" },
--filetypes = { 'text' },
--root_dir = vim.fn.getcwd(), -- Use PWD as project root dir.
--})


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
