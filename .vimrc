"" VimRC for C Programming
"" Author: TimERTy
"
"Colorscheme
color elflord
set background=dark
"
"Line Numbers
set number
highlight lineNr ctermfg=white
"
"Indenting
set smartindent
set autoindent
filetype indent on
"
"Tabbing
set tabstop=8
set shiftwidth=4
set expandtab
set smarttab
set softtabstop=0
"
"Movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
"
"Search
set incsearch
set hlsearch
"
"
set lazyredraw
"
"Rm error Sound
set noerrorbells
set novisualbell
set t_vb=
set tm=500
"
"Cursor
set cursorline
highlight CursorLine cterm=none ctermfg=None ctermbg=darkgrey
"
"Mapping
nmap <F2> :w<CR>
imap <F2> <ESC>:w<CR>i
ino #i #include 
ino #d #define 
"
"Brackets
ino " ""<left>
ino ' ''<left>
ino ( ()<left>
ino [ []<left>
ino { {}<left>
ino {<CR> {<CR>}<ESC>O
