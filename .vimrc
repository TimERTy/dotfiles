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
set foldmethod=syntax
set foldlevelstart=10
set foldnestmax=10
nno <space> za
"
"Tabbing
set tabstop=8
set shiftwidth=4
set expandtab
set smarttab
set softtabstop=0
"
"Movement
nnoremap <C-j> :tabfirst<CR>
nnoremap <C-k> :tablast<CR>
nnoremap <C-h> :tabp<CR>
nnoremap <C-l> :tabn<CR>
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
" to minimise unwanted insertion
ino "" ""
ino '' ''
ino () ()
ino [] []
ino {} {}
"
"Toggle between number and relativenumber
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

ino <F3> <ESC>:call ToggleNumber()<CR>i
nno <F3> :call ToggleNumber()<CR>
"
"Stop accidnetly holding down <SHIFT> 
command! W w
command! Wq wq
command! Q q
command! Write w !sudo tee % > /dev/null
"
"Skeleton Files
"       Bash
if has("autocmd")
  augroup templates
    autocmd BufNewFile *.sh 0r ~/.vim/templates/skeleton.sh
"    autocmd BufNewFile *.js 0r ~/.vim/templates/skeleton.js
"    autocmd BufNewFile *.c 0r ~/.vim/templates/skeleton.c
"    autocmd BufNewFile *.cpp 0r ~/.vim/templates/skeleton.cpp
"    autocmd BufNewFile *.java 0r ~/.vim/templates/skeleton.java
  augroup END
endif
"
"Negative Reinforcment
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
