-- Aliases For Convenience
local cmd = vim.cmd  -- To execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- To call Vim functions e.g. fn.bufnr()
local g = vim.g      -- A table to access global variables
local opt = vim.opt  -- To set options

-- Install Packages
require 'paq-nvim' {
    'savq/paq-nvim';                      -- Manage the package manager
    'sainnhe/gruvbox-material';           -- A nice colorscheme
    'hoob3rt/lualine.nvim';               -- A snazzy status-line
    'nvim-treesitter/nvim-treesitter';    -- Support for better syntax highlighting
    'neovim/nvim-lspconfig';              -- Automatically launch LSP servers
    'nvim-lua/lsp_extensions.nvim';       -- Enable LSP protocol extensions
    'hrsh7th/nvim-compe';                 -- Enable completions for LSP
    'ray-x/lsp_signature.nvim';           -- Enable function parameter hints in LSP
    'glepnir/lspsaga.nvim';               -- Add some nice UI components to LSP
    'TheLostLambda/lualine-lsp-progress'; -- Add an LSP status-bar widget
    'RRethy/vim-illuminate';              -- Use LSP to highlight hovered symbols
    'hrsh7th/vim-vsnip';                  -- Basic snippet support
    'rafamadriz/friendly-snippets';       -- A collection of community snippets
    'nvim-telescope/telescope.nvim';      -- A powerful fuzzy-finder
    'nvim-lua/plenary.nvim';              -- A dependency for Telescope
    'nvim-lua/popup.nvim';                -- Another dependency for Telescope
    'folke/which-key.nvim';               -- An way to show all available keybinds
    'folke/trouble.nvim';                 -- Summarizes errors and lints
    'kyazdani42/nvim-web-devicons';       -- Add some nice icons for filetypes
}

-- Built-In Options
opt.expandtab = true      -- Use spaces instead of tabs
opt.hidden = true         -- Enable background buffers
opt.ignorecase = true     -- Ignore case
opt.joinspaces = false    -- No double spaces with join
opt.list = true           -- Show some invisible characters
opt.number = true         -- Show line numbers
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 4         -- Lines of context
opt.shiftround = true     -- Round indent
opt.shiftwidth = 4        -- Size of an indent
opt.sidescrolloff = 8     -- Columns of context
opt.smartcase = true      -- Do not ignore case with capitals
opt.smartindent = true    -- Insert indents automatically
opt.splitbelow = true     -- Put new windows below current
opt.splitright = true     -- Put new windows right of current
opt.tabstop = 4           -- Number of spaces tabs count for
opt.termguicolors = true  -- True color support
opt.wrap = false          -- Disable line wrap
opt.cursorline = true     -- Highlight the selected line
opt.signcolumn = 'yes'    -- Show diagnostics in their own column
opt.spell = true          -- Enable spell checking
opt.spelllang = 'en_us'   -- Set language to English

-- Make Things Look Nice
cmd 'colorscheme gruvbox-material'

-- Set Up Intelligent Highlighting & Indentation
require('nvim-treesitter.configs').setup {
    ensure_installed = 'maintained',
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true
    },
    indent = {enable = true},
}

-- Set Up LSP UI & Servers
require('lspsaga').init_lsp_saga()

local universal_config = {
    on_attach = function(client) 
        require('illuminate').on_attach(client)
    end
}

local lsp = require('lspconfig')
lsp.rust_analyzer.setup(universal_config)
lsp.clangd.setup(universal_config)
lsp.pyls.setup(universal_config)

-- Load a Fancy Status-Line (With LSP Status)
require('lualine').setup {
    options = {theme = 'gruvbox_material'},
    sections = {
        lualine_c = {
            {'filename', separator = ''},
            'lsp_progress'
        }
    }
}

-- Set Up Auto-Completion & Snippets
opt.completeopt = {'menuone', 'noinsert', 'noselect'}
opt.shortmess:append({ c = true })
require('lsp_signature').on_attach {
    hint_prefix = '',
    use_lspsaga = true
}

require('compe').setup {
    source = {
        path = true;
        buffer = true;
        calc = true;
        nvim_lsp = true;
        nvim_lua = true;
        vsnip = true;
    },
    preselect = 'always'
}

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

-- Keep an eye on this https://github.com/neovim/neovim/pull/12378
cmd [[
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua require('lsp_extensions').inlay_hints(inlay_hints)
]]

-- Key Bindings
g.mapleader = " "

local map = vim.api.nvim_set_keymap
local ns = {noremap = true, silent = true}
local n = {noremap = true}
local e = {expr = true}

-- Tab Completion & Snippet Traversal
map('i', '<CR>',    [[pumvisible() ? compe#close() . "\<CR>" : "\<CR>"]], e)
map('i', '<Tab>',   [[vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : compe#confirm("<Tab>")]], e)
map('s', '<Tab>',   [[vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'               ]], e)
map('i', '<S-Tab>', [[vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-n>'               ]], e)
map('s', '<S-Tab>', [[vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'             ]], e)

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
map('n', 'K', ':Lspsaga hover_doc<CR>', ns)
map('n', '<C-u>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', ns)
map('n', '<C-d>', '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', ns)

map('n', 'gh', ':Lspsaga lsp_finder<CR>', ns)

map('n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', ns)
map('n', '<leader>lrn', ':Lspsaga rename<CR>', ns)
map('n', '<leader>lca', ':Lspsaga code_action<CR>', ns)
map('v', '<leader>lca', ':<C-U>Lspsaga range_code_action<CR>', ns)
map('n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', ns)

-- Float Terminal From Lspsaga
map('n', '<C-t>', ':Lspsaga open_floaterm<CR>', ns)
map('t', '<C-t>', '<C-\\><C-n>:Lspsaga close_floaterm<CR>', ns)

-- Miscellaneous
map('n', '<C-l>', '<cmd>noh<CR>', n)    -- Clear highlights
map('n', '<leader>o', 'm`o<Esc>``', n)  -- Insert a newline in normal mode
map('n', '<leader>.', 'yyp', n)         -- Duplicate the current line downwards

-- Telescope Triggers
map('n', '<leader>tf', '<cmd>lua require("telescope.builtin").find_files()<CR>', n)
map('n', '<leader>tg', '<cmd>lua require("telescope.builtin").live_grep()<CR>', n)
map('n', '<leader>tb', '<cmd>lua require("telescope.builtin").buffers()<CR>', n)
map('n', '<leader>ts', '<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>', n)
map('n', '<leader>tt', '<cmd>lua require("telescope.builtin").treesitter()<CR>', n)

-- Trouble
map('n', '<leader>d', ':TroubleToggle<CR>', ns)
