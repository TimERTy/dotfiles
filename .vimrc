"" VimRC for C Programming
"" Author: TimERTy
"
"Colorscheme
set t_Co=256
color elflord
set background=dark
"
"Line Numbers
set number
highlight lineNr ctermfg=white
"
"Cursor
set cursorline
highlight CursorLine cterm=none ctermfg=None ctermbg=darkgrey
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
"Movement between tabs
nnoremap <silent> <C-j> :tabfirst<CR>
nnoremap <silent> <C-k> :tablast<CR>
nnoremap <silent> <C-h> :tabp<CR>
nnoremap <silent> <C-l> :tabn<CR>
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
"Mapping
nmap <F2> :w<CR>
imap <F2> <ESC>:w<CR>i
ino #i #include 
ino #d #define 
"
""Brackets
"ino " ""<left>
"ino ' ''<left>
"ino ( ()<left>
"ino [ []<left>
"ino { {}<left>
"ino {<CR> {<CR>}<ESC>O
"" to minimise unwanted insertion
"ino "" ""
"ino '' ''
"ino () ()
"ino [] []
"ino {} {}
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

ino <silent> <F3> <ESC>:call ToggleNumber()<CR>i
nno <silent> <F3> :call ToggleNumber()<CR>
"
"Stop accidnetly holding down <SHIFT> 
"command! W w
"command! Wq wq
"command! Q q
"command! Write w !sudo tee % > /dev/null
command! W w !sudo tee % > /dev/null
"
"Skeleton Files
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
"
"Enable Project Specific vimrc
" this allows for project specific vimrc files
" eg ./project/.vimrc
set exrc
set secure
" I use local .vimrc to install plugins for specific projects
" with vim-plug this allows for easy project customisability
