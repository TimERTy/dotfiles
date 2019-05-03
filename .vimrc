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
"Folding
set foldenable
set foldmethod=indent
set foldlevelstart=10
set foldnestmax=10
"
"Tabbing
set tabstop=8
set shiftwidth=4
set expandtab
set smarttab
set softtabstop=0
"
"Movement
nnoremap <C-j> :tabfirst
nnoremap <C-k> :tablast
nnoremap <C-h> :tabp
nnoremap <C-l> :tabn
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
