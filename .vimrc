" General
set nocompatible            " get rid of Vi compatibility mode. SET FIRST!
filetype plugin indent on   " filetype detection[ON] plugin[ON] indent[ON]

" Theme / Colour
set t_Co=256                " enable 256-color mode.
syntax enable               " enable syntax highlighting (previously syntax on).
set background=dark         " dark background for colorscheme
colorscheme retrobox        " set colorscheme

" Vim UI
set number                  " show line numbers
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

" Text Formatting
set autoindent              " auto-indent
set tabstop=4               " tab spacing
set softtabstop=4           " unify
set shiftwidth=4            " indent/outdent by 4 columns
set shiftround              " always indent/outdent to the nearest tabstop
set expandtab               " use spaces instead of tabs
set nowrap                  " don't wrap text
