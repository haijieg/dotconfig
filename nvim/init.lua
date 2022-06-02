local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-------------------- PROVIDERS -------------------------------
g['python3_host_prog'] = "/opt/homebrew/Caskroom/miniforge/base/bin/python"
-------------------- PLUGINS -------------------------------
require "paq" {
	{'savq/paq-nvim', opt = true};    -- paq-nvim manages itself
  {'franbach/miramare'};
  {'nvim-lualine/lualine.nvim'};
  {'kyazdani42/nvim-web-devicons'};
 	{'nvim-treesitter/nvim-treesitter'};
 	{'neovim/nvim-lspconfig'};
  {'hrsh7th/nvim-cmp'};
  {'hrsh7th/cmp-nvim-lsp'};
  {'saadparwaiz1/cmp_luasnip'};
  {'L3MON4D3/LuaSnip'};
  {'cdelledonne/vim-cmake'};
  {'alepez/vim-gtest'};
  {'nvim-lua/plenary.nvim'};
  {'BurntSushi/ripgrep'};
  {'nvim-telescope/telescope.nvim'};
  {'nvim-telescope/telescope-file-browser.nvim'};
  {'tpope/vim-surround'};
  {'terrortylor/nvim-comment'};
  {'vim-scripts/a.vim'};
  {'tpope/vim-repeat'};
  {'pappasam/nvim-repl'};
}

-- UI Telescope and Status
require('telescope').load_extension 'file_browser'
require('lualine').setup()
require('nvim-web-devicons').get_icons()

-- Completion
require('nvim_comment').setup()
require('nvimcmp')

-- Cmake and GTest
vim.cmd('source ~/.config/nvim/cmake.vim')
local gtest_command = "build/Debug/test/cpptests" 
if fn.filereadable(gtest_command) then
  print('Found cpptest command: ', gtest_command)
  g['gtest#gtest_command'] = gtest_command
end

-- REPL
g['repl_filetype_commands'] = {python='bpython -q'}

-------------------- OPTIONS -------------------------------
opt.completeopt = {'menuone', 'noinsert', 'noselect'}  -- Completion options (for deoplete)
opt.expandtab = true                -- Use spaces instead of tabs
opt.hidden = true                   -- Enable background buffers
opt.ignorecase = true               -- Ignore case
opt.joinspaces = false              -- No double spaces with join
opt.number = true                   -- Show line numbers
opt.scrolloff = 4                   -- Lines of context
opt.shiftround = true               -- Round indent
opt.shiftwidth = 2                  -- Size of an indent
opt.sidescrolloff = 8               -- Columns of context
opt.smartcase = true                -- Do not ignore case with capitals
opt.smartindent = true              -- Insert indents automatically
opt.tabstop = 2                     -- Number of spaces tabs count for
opt.termguicolors = true            -- True color support
opt.wildmode = {'list', 'longest'}  -- Command-line completion mode
opt.wrap = true                     -- Disable line wrap
cmd 'colorscheme miramare'            -- Put your favorite colorscheme here
-------------------- MAPPINGS ------------------------------

-- C-{h,i,j,k} for window navigation -- 
map('t', '<C-h>', '<C-\\><C-N><C-w>h')
map('i', '<C-h>', '<C-\\><C-N><C-w>h')
map('n', '<C-h>', '<C-w>h')
map('t', '<C-j>', '<C-\\><C-N><C-w>j')
map('i', '<C-j>', '<C-\\><C-N><C-w>j')
map('n', '<C-j>', '<C-w>j')
map('t', '<C-k>', '<C-\\><C-N><C-w>k')
map('i', '<C-k>', '<C-\\><C-N><C-w>k')
map('n', '<C-k>', '<C-w>k')
map('t', '<C-l>', '<C-\\><C-N><C-w>l')
map('i', '<C-l>', '<C-\\><C-N><C-w>l')
map('n', '<C-l>', '<C-w>l')

-- Telescope --
map('n', '<leader>t', '<cmd>lua require("telescope.builtin").find_files()<CR>')
map('n', '<leader>b', '<cmd>lua require("telescope.builtin").buffers()<CR>')
map('n', '<leader>g', '<cmd>lua require("telescope.builtin").live_grep()<CR>')
map('n', '<leader>fh', '<cmd>lua requires("telescope.builtin").help_tags()<CR>')
map('n', '<C-n>', '<cmd>Telescope file_browser<CR>')

-- CMake --
map('n', '<leader>cg', '<cmd>CMakeGenerate<CR>')
map('n', '<leader>cb', '<cmd>CMakeBuild -j4<CR>')

-- GoogleTest --
map('n', '<leader>gt', '<cmd>GTestRunUnderCursor<cr>')

-- REPL --
map('n', '<leader>vip', '<cmd>ReplToggle<CR>')
map('n', '<leader>w', '<plug>ReplSendLine')
map('v', '<leader>w', '<plug>ReplSendVisual')
---------------------- TREE-SITTER ---------------------------
local ts = require 'nvim-treesitter.configs'
ts.setup {
  ensure_installed = 'all',
  highlight = {enable = true},
  indent = {enable = true}
}
-------------------- LSP --------------------------
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
map('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  print("LSP started")
  -- Enable completion triggered by <c-x><c-o>
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pylsp', 'clangd' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    },
    capabilities = capabilities
  }
end
