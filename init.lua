-- Aliases For Convenience
local cmd = vim.cmd  -- To execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- To call Vim functions e.g. fn.bufnr()
local g = vim.g      -- A table to access global variables
local opt = vim.opt  -- To set options

-- Install Packages
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'           -- Manage the package manager
  use 'ellisonleao/gruvbox.nvim'         -- A nice colorscheme
  use 'hoob3rt/lualine.nvim'             -- A snazzy status-line
  use 'nvim-treesitter/nvim-treesitter'  -- Support for better syntax highlighting
  use 'neovim/nvim-lspconfig'            -- Automatically launch LSP servers
  use 'nvim-lua/lsp_extensions.nvim'     -- Enable LSP protocol extensions
  use 'hrsh7th/nvim-cmp'                 -- Enable completions for nvim
  use 'hrsh7th/cmp-nvim-lsp'             -- LSP completions
  use 'hrsh7th/cmp-buffer'               -- Buffer completions
  use 'hrsh7th/cmp-path'                 -- Path completions
  use 'hrsh7th/cmp-cmdline'              -- Command completions
  use 'ray-x/lsp_signature.nvim'         -- Enable function parameter hints in LSP
  use 'tami5/lspsaga.nvim'               -- Add some nice UI components to LSP
  use 'RRethy/vim-illuminate'            -- Use LSP to highlight hovered symbols
  use 'L3MON4D3/LuaSnip'                 -- Basic snippet support
  use 'saadparwaiz1/cmp_luasnip'         -- LuaSnip nvim-cmp source
  use 'rafamadriz/friendly-snippets'     -- A collection of community snippets
  use 'ggandor/leap.nvim'                -- Provides enhanced buffer navigation
  use 'nvim-telescope/telescope.nvim'    -- A powerful fuzzy-finder
  use 'nvim-lua/plenary.nvim'            -- A dependency for Telescope
  use 'nvim-lua/popup.nvim'              -- Another dependency for Telescope
  use 'folke/which-key.nvim'             -- An way to show all available keybinds
  use 'folke/trouble.nvim'               -- Summarizes errors and lints
  use 'kyazdani42/nvim-web-devicons'     -- Add some nice icons for filetypes
  use 'windwp/nvim-autopairs'            -- Automatically pair some characters
  use 'numToStr/Comment.nvim'            -- Make commenting blocks and lines easier
  use 'Olical/conjure'                   -- Add lovely lisp support
  use 'clojure-vim/vim-jack-in'          -- Add CIDER middleware for Clojure
  use 'tpope/vim-dispatch'               -- A dependency for `vim-jack-in`
  use 'radenling/vim-dispatch-neovim'    -- A neovim patch for `vim-dispatch`
  -- use 'ShinKage/idris2-nvim'             -- Some nicer Idris LSP support
  -- use 'MunifTanjim/nui.nvim'             -- A dependency for `idris2-nvim`
  -- Support and syntax highlighting for Unison (.u) files
  -- use {
  --   'unisonweb/unison',
  --   branch = 'trunk',
  --   rtp = 'editor-support/vim'
  -- }
end)

-- Built-In Options
opt.expandtab = true           -- Use spaces instead of tabs
opt.hidden = true              -- Enable background buffers
opt.ignorecase = true          -- Ignore case
opt.joinspaces = false         -- No double spaces with join
opt.list = true                -- Show some invisible characters
opt.number = true              -- Show line numbers
opt.relativenumber = true      -- Relative line numbers
opt.scrolloff = 4              -- Lines of context
opt.shiftround = true          -- Round indent
opt.shiftwidth = 2             -- Size of an indent
opt.sidescrolloff = 8          -- Columns of context
opt.smartcase = true           -- Do not ignore case with capitals
opt.smartindent = true         -- Insert indents automatically
opt.splitbelow = true          -- Put new windows below current
opt.splitright = true          -- Put new windows right of current
opt.tabstop = 2                -- Number of spaces tabs count for
opt.termguicolors = true       -- True color support
opt.wrap = false               -- Disable line wrap
opt.cursorline = true          -- Highlight the selected line
opt.signcolumn = 'yes'         -- Show diagnostics in their own column
opt.spell = true               -- Enable spell checking
opt.spelllang = 'en_gb'        -- Set language to English
opt.updatetime = 750           -- Trigger timeouts every 750ms
opt.autoread = true            -- Automatically reload changed files
opt.swapfile = false           -- Disable the swap files (allow multiple access)
opt.clipboard = 'unnamedplus'  -- Use the system clipboard

-- Make Things Look Nice
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = false,
  italic = false,
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "soft", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})
vim.cmd("colorscheme gruvbox")

-- Set up enhanced buffer navigation
require('leap').set_default_keymaps()

-- Set Up Intelligent Highlighting & Indentation
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true
  },
  indent = {enable = true},
}

-- Set Up Intelligent Commenting
require('Comment').setup()

-- Treesitter Based Folding
-- opt.foldmethod = 'expr'
-- opt.foldexpr = 'nvim_treesitter#foldexpr()'

-- Interactive development with Conjure
-- TODO: Make this a lua function call?
g["conjure#filetypes"] = { "lisp" }

-- Set Up LSP UI & Servers
require('lspsaga').init_lsp_saga()

local universal_config = {
  on_attach = function(client)
    -- require('illuminate').on_attach(client)
  end
}

local lsp = require('lspconfig')
lsp.rust_analyzer.setup(universal_config)
lsp.clangd.setup {
  on_attach = universal_config.on_attach,
  cmd = { 'clangd', '--background-index', '-header-insertion=never' }
}
lsp.pylsp.setup(universal_config)
lsp.julials.setup(universal_config)
lsp.clojure_lsp.setup(universal_config)
lsp.emmet_ls.setup(universal_config)
lsp.svelte.setup(universal_config)
lsp.tsserver.setup(universal_config)
lsp.html.setup {
  on_attach = universal_config.on_attach,
  filetypes = { "html", "htmldjango" }
}
lsp.cssls.setup(universal_config)
lsp.eslint.setup(universal_config)
lsp.jsonls.setup(universal_config)
lsp.tailwindcss.setup(universal_config)
lsp.unison.setup(universal_config)

-- Enable an enhanced version of the idris2 LSP
-- require('idris2').setup({})

-- Load a Fancy Status-Line
require('lualine').setup()

-- Set Up Auto-Completion & Snippets
opt.completeopt = {'menuone', 'noinsert', 'noselect'}
opt.shortmess:append({ c = true })
require('lsp_signature').on_attach {
  hint_prefix = '',
  use_lspsaga = true
}
-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  })
})

-- Complete Bracket Pairs
require('nvim-autopairs').setup()
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- Set Up Which-Key To Show Keybindings & Spelling
require('which-key').setup {
  plugins = {
    spelling = {enabled = true}
  }
}

-- Summarise Buffer Diagnostics
require('trouble').setup()

-- Enable Some LSP Protocol Extensions For Rust
inlay_hints = {
  prefix = '',
  highlight = 'NonText',
  enabled = {'TypeHint', 'ChainingHint'}
}

-- Keep an eye on this https://github.com/neovim/neovim/pull/14661
--cmd [[
--autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua require('lsp_extensions').inlay_hints(inlay_hints)
--]]

-- Reload files changed outside of Neovim
cmd [[
autocmd CursorHold,FocusGained * checktime
]]

-- Some aliases for case-insensitivity
cmd ":command! W w"
cmd ":command! Wq wq"

-- Key Bindings
g.mapleader = " "

local map = vim.api.nvim_set_keymap
local ns = {noremap = true, silent = true}
local n = {noremap = true}
local e = {expr = true}

-- Snippet Traversal
map('s', '<C-l>', '"<Plug>(vsnip-jump-next)"', e)
map('i', '<C-l>', '"<Plug>(vsnip-jump-next)"', e)
map('s', '<C-h>', '"<Plug>(vsnip-jump-prev)"', e)
map('i', '<C-h>', '"<Plug>(vsnip-jump-prev)"', e)

-- LSP Movement
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', ns)
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', ns)
map('n', '[d', ':Lspsaga diagnostic_jump_next<CR>', ns)
map('n', ']d', ':Lspsaga diagnostic_jump_prev<CR>', ns)

-- LSP Workspaces
map('n', '<leader>law', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', ns)
map('n', '<leader>lrw', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', ns)
map('n', '<leader>llw', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', ns)

-- LSP Actions
map('n', 'K',     ':Lspsaga hover_doc<CR>', ns)
map('n', '<C-u>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', ns)
map('n', '<C-d>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', ns)

map('n', 'gh', ':Lspsaga lsp_finder<CR>', ns)

map('n', '<leader>lt',  '<cmd>lua vim.lsp.buf.type_definition()<CR>', ns)
map('n', '<leader>lrn', ':Lspsaga rename<CR>', ns)
map('n', '<leader>lca', ':Lspsaga code_action<CR>', ns)
map('v', '<leader>lca', ':<C-U>Lspsaga range_code_action<CR>', ns)
map('n', '<leader>lf',  '<cmd>lua vim.lsp.buf.formatting()<CR>', ns)

-- Float Terminal From Lspsaga
map('n', '<C-t>', ':Lspsaga open_floaterm<CR>', ns)
map('t', '<C-t>', '<C-\\><C-n>:Lspsaga close_floaterm<CR>', ns)

-- Miscellaneous
map('n', '<leader>c', '<cmd>noh<CR>', n) -- Clear highlights
map('n', '<leader>o', 'm`o<Esc>``', n)   -- Insert a newline in normal mode
map('n', '<leader>.', 'yyp', n)          -- Duplicate the current line downwards
map('n', '<leader>b', '<cmd>b#<CR>', ns) -- Switch to the previous buffer
map('n', '<leader>w', 'm`gqip``', ns)        -- Wrap the current paragraph

-- Telescope Triggers
map('n', '<leader>tf', '<cmd>lua require("telescope.builtin").find_files()<CR>', n)
map('n', '<leader>tg', '<cmd>lua require("telescope.builtin").live_grep()<CR>', n)
map('n', '<leader>tb', '<cmd>lua require("telescope.builtin").buffers()<CR>', n)
map('n', '<leader>ts', '<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>', n)
map('n', '<leader>tt', '<cmd>lua require("telescope.builtin").treesitter()<CR>', n)

-- Trouble
map('n', '<leader>d', ':TroubleToggle<CR>', ns)
