" General
set nocompatible            " get rid of Vi compatibility mode. SET FIRST!
filetype plugin indent on   " filetype detection[ON] plugin[ON] indent[ON]


" Plugins
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'yegappan/lsp'
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-sleuth'
Plug 'machakann/vim-highlightedyank'

call plug#end()


" Theme / Colour
set t_Co=256                " will fallback to 256 color mode if no termguicolors

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
    set termguicolors
endif

syntax enable               " enable syntax highlighting (previously syntax on).
set background=dark         " dark mode for colorscheme
let g:gruvbox_italic=1
autocmd vimenter * ++nested colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = 0
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1
let g:highlightedyank_highlight_duration = 200


" Vim UI
set number                  " show line numbers
set relativenumber	        " show relative line numbers
autocmd InsertEnter * :set norelativenumber " Absolute line numbers in insert mode
autocmd InsertLeave * :set relativenumber   " Relative otherwise
set ruler                   " Always show info along bottom.
set ignorecase              " Make searches case-insensitive.
set incsearch               " But do highlight as you type your search.
set hlsearch                " highlight seach results
set laststatus=2            " last window always has a statusline
set mouse=a                 " enable mouse usage
set nolist                  " do not show whitespace characters by default
set lcs+=space:·            " show spaces as · when set list is on
set cursorline              " highlight the line the cursor is on
set visualbell              " visual bell indicator (screen flash)
set showmatch               " show matching parentheses
set scrolloff=5             " always show 5 lines of context around selected line
set timeout timeoutlen=250  " wait 250ms between key combos

" Cursor settings:

"  1 -> blinking block
"  2 -> solid block
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar

let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)


" Text Formatting
set autoindent              " auto-indent
set tabstop=4               " tab spacing
set softtabstop=4           " unify
set shiftwidth=4            " indent/outdent by 4 columns
set shiftround              " always indent/outdent to the nearest tabstop
set expandtab               " use spaces instead of tabs
set linebreak               " don't break words when wrapping
set nowrap                  " don't wrap text


" Key Remapping
let mapleader = " "
inoremap jk <esc>
vnoremap jk <esc>
nnoremap gd :LspGotoDefinition<CR>
nnoremap gD :LspGotoDeclaration<CR>
nnoremap gr :LspShowReferences<CR>
nnoremap K  :LspHover<CR>
nnoremap <leader>cd :LspDiag current<CR>
nnoremap <leader>nd :LspDiagNextWrap<CR>
nnoremap <leader>pd :LspDiagPrevWrap<CR>
nnoremap <leader>sd :LspDiag show<CR>
nnoremap <leader>cr :LspRename<CR>
nnoremap <leader>ca :LspCodeAction<CR>
vnoremap <leader>ca :LspCodeAction<CR>
nnoremap <leader>cf :LspFormat<CR>
vnoremap <leader>cf :LspFormat<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>fg :Rg<Space>
noremap <leader><leader> :noh<CR>:call clearmatches()<CR>
nnoremap n nzz
nnoremap N Nzz
nnoremap * Nzz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz
" replace the :W shortcut for :Windows command from fzf with :w
cnoreabbrev <expr> W (getcmdtype() == ':' && getcmdline() =~ '^W$')? 'w' : 'W'
cnoreabbrev <expr> Q (getcmdtype() == ':' && getcmdline() =~ '^Q$')? 'q' : 'Q'


" LSP
let lspOpts = #{
            \ autoHighlightDiag: v:true,
            \ popupBorder: v:true,
            \ semanticHighlight: v:true
            \ }

autocmd User LspSetup call LspOptionsSet(lspOpts)

" language servers
let lspServers =  [#{
            \    name: 'clangd',
            \    filetype: ['c', 'cpp'],
            \    path: 'clangd',
            \    args: [
            \       '--background-index',
            \       '--pretty',
            \       '--header-insertion=iwyu',
            \       '--clang-tidy'
            \   ]
            \ },
            \ #{
            \   name: 'rustlang',
            \   filetype: ['rust'],
            \   path: 'rust-analyzer',
            \   args: [],
            \   syncInit: v:true,
            \   initializationOptions: {
            \       'completion': {
            \           'autoimport': { 'enable': v:true }
            \       }
            \   }
            \ }]

autocmd User LspSetup call LspAddServer(lspServers)

