" General
set nocompatible            " get rid of Vi compatibility mode. SET FIRST!
filetype indent on   " filetype detection[ON] plugin[ON] indent[ON]

" Theme / Colour
set t_Co=256                " will fallback to 256 color mode if no termguicolors

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
    set termguicolors
endif

syntax enable               " enable syntax highlighting (previously syntax on).
colorscheme retrobox
set background=dark         " dark mode for colorscheme

" Vim UI
set number                  " show line numbers
set relativenumber	        " show relative line numbers
autocmd InsertEnter * :set norelativenumber " Absolute line numbers in insert mode
autocmd InsertLeave * :set relativenumber   " Relative otherwise
set ruler                   " Always show info along bottom.
set smartcase               " Make searches case-insensitive unless capitals
set incsearch               " But do highlight as you type your search.
set hlsearch                " highlight seach results
set laststatus=2            " last window always has a statusline
set mouse=a                 " enable mouse usage
set nolist                  " do not show whitespace characters by default
set lcs+=space:·            " show spaces as · when set list is on
set cursorline              " highlight the line the cursor is on
set visualbell              " visual bell indicator (screen flash)
set showmatch               " show matching parentheses
set scrolloff=8             " always show 5 lines of context around selected line
set timeout timeoutlen=300  " wait 300ms between key combos

" Cursor settings:

"  1 -> blinking block
"  2 -> solid block
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar

let &t_SI.="\e[6 q" "SI = INSERT mode
let &t_EI.="\e[2 q" "EI = NORMAL mode (ELSE)


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
noremap <leader><leader> :noh<CR>:call clearmatches()<CR>
nnoremap <leader>wf :w<CR>
