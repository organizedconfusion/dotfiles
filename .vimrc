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
nnoremap gd :LspGotoDefinition<CR>
nnoremap gD :LspGotoDeclaration<CR>
nnoremap gr :LspShowReferences<CR>
nnoremap K  :LspHover<CR>
nnoremap gl :LspDiag current<CR>
nnoremap <leader>nd :LspDiag next \| LspDiag current<CR>
nnoremap <leader>pd :LspDiag prev \| LspDiag current<CR>
nnoremap <leader>sd :LspDiag show<CR>
nnoremap <leader>cr :LspRename<CR>

" LSP
packadd lsp

   call LspOptionsSet(#{
        \ autoHighlightDiag: v:true,
        \ popupBorder: v:true,
        \ semanticHighlight: v:true,
        \ autoHighlight: v:true
        \ })

    " Clangd language server
    call LspAddServer([#{
        \    name: 'clangd',
        \    filetype: ['c', 'cpp'],
        \    path: 'clangd',
        \    args: [
        \       '--background-index',
        \       '--pretty',
        \       '--header-insertion=iwyu',
        \       '--clang-tidy'
        \    ]
        \ }])
