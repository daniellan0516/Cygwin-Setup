set statusline=[%f]%m%r%h\ [%{getcwd()}]\ [%{&ff},%{&fenc}%{(&bomb?\",BOM\":\"\")}]%=[code=%b,\\u%04B]\ [col:%c,pos:%v]\ [line:%l/%L,%p%%]
" 拼字檢查
set nospell
let g:enable_spelunker_vim = 1
let g:enable_spelunker_vim_on_readonly = 0
let g:spelunker_max_hi_words_each_buf = 100
let g:spelunker_check_type = 1
let g:spelunker_highlight_type = 1
let g:spelunker_disable_uri_checking = 1
let g:spelunker_disable_email_checking = 1
let g:spelunker_disable_account_name_checking = 1
let g:spelunker_disable_acronym_checking = 1
let g:spelunker_disable_backquoted_checking = 1
let g:spelunker_disable_auto_group = 1
augroup spelunker
  autocmd!
  autocmd BufWinEnter,BufWritePost *.vim,*.js,*.jsx,*.json,*.md call spelunker#check()
  autocmd CursorHold *.vim,*.js,*.jsx,*.json,*.md call spelunker#check_displayed_words()
augroup END
let g:spelunker_spell_bad_group = 'SpelunkerSpellBad'
let g:spelunker_complex_or_compound_word_group = 'SpelunkerComplexOrCompoundWord'
highlight SpelunkerSpellBad cterm=underline ctermfg=247 gui=underline guifg=#9e9e9e
highlight SpelunkerComplexOrCompoundWord cterm=underline ctermfg=NONE gui=underline guifg=NONE

" 設定plugin的安裝路徑
let g:plug_home = "C:\\cygwin\\root\\home\\azure\\.nvim_plugins"

" -- 自動開啟縮排顏色
let g:indent_guides_enable_on_vim_startup = 1
let mapleader = "\\" 

" -- 檔案參照功能
filetype on
filetype plugin on
filetype indent on
syntax on

" -- 設定tab鍵寬度
set tabstop=2
set shiftwidth=2
set expandtab
let g:context_nvim_no_redraw = 1

" -- 可以用滑鼠
set mouse=a

" -- 顯示行號
set relativenumber
set nu
set termguicolors

" -- 設定檔案編碼方式
set encoding=utf8
set fileencoding=utf-8
set encoding=utf-8
set ff=unix

" -- 開啟狀態欄
set laststatus=2
set cursorline

" -- 自動補全
set completeopt=menu,menuone,noselect

augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" -- 自動回到上次編輯位置
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" -- 安裝外掛
call plug#begin()
  Plug 'kevinhwang91/nvim-hlslens'
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'Yggdroot/indentLine'
  Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
  Plug 'jiangmiao/auto-pairs'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'mfussenegger/nvim-dap'
  Plug 'tpope/vim-fugitive'
  Plug 'karb94/neoscroll.nvim'
  Plug 'lilydjwg/colorizer'
  Plug 'neovim/nvim-lspconfig'
  Plug 'tmhedberg/SimpylFold'
  Plug 'mattn/emmet-vim'
  Plug 'mbbill/undotree'
  Plug 'ryanoasis/vim-devicons'
  Plug 'LnL7/vim-nix'
  Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
  Plug 'posva/vim-vue'
  Plug 'preservim/nerdtree'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'kamykn/spelunker.vim'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
call plug#end()

lua << EOF
  -- 啟用LSP
  local saga = require 'lspsaga'
  saga.init_lsp_saga()
  require("nvim-lsp-installer").setup {
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
  }
  local kopts = {noremap = true, silent = true}
  vim.api.nvim_set_keymap('n', 'n',[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],kopts)
  vim.api.nvim_set_keymap('n', 'N',[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],kopts)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  require'lspconfig'.html.setup {
    capabilities = capabilities,
  }

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  require'lspconfig'.cssls.setup {
    capabilities = capabilities,
  }
  vim.opt.termguicolors = true

  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    window = {
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  --  capabilities = capabilities
  --}

EOF

" -- 設定主題
colorscheme tokyonight
" -- 最下面的快捷鍵設定，會覆蓋掉上面的
nmap ff <Cmd>Telescope find_files<cr>
"  -- ctrl+/設定為開啟、關閉註釋
" 注意！Unix作業系統中的ctrl+/會被認為是ctrl+_，所以下面有這樣一條if判斷
if has('win32')
    nmap <C-/> gcc
    vmap <C-/> gcc
else
    nmap <C-_> gcc
    vmap <C-_> gcc
endif
" -- 設定smooth換頁
nmap <PageUp> <C-u>
nmap <PageDown> <C-d>

" -- Ctrl + s 儲存
nmap <silent><C-s> :w<CR>
nmap <silent><C-c> :bdelete!<CR>
" -- F5打開側邊資料夾
nmap <silent><F5> :NERDTreeToggle <CR>
" -- tab & Buffer切換
nnoremap <leader>1 :1tabnext<CR>
nnoremap <leader>2 :2tabnext<CR>
nnoremap <leader>3 :3tabnext<CR>
nnoremap <leader>4 :4tabnext<CR>
nnoremap <leader>5 :5tabnext<CR>
nnoremap <leader>6 :6tabnext<CR>
nnoremap <leader>7 :7tabnext<CR>
nnoremap <leader>8 :8tabnext<CR>
nnoremap <leader>9 :9tabnext<CR>

" -- gf 用新tab開啟檔案
nnoremap gf <C-W>gf
vnoremap gf <C-W>gf

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

let NERDTreeMapOpenInTab='<ENTER>'
hi CursorLine gui=underline
