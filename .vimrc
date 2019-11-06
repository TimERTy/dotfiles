"" VimRC for All Programming
"" Author: TimERTy

"
"Colorscheme
set t_Co=256
color elflord
set background=dark

"
"Line Numbers
set number
hi lineNr ctermfg=white

"
"Cursor
set cursorline
hi CursorLine cterm=none ctermfg=None ctermbg=darkgrey

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
nno <space><space> za
"au FileType html set foldmethod=indent

"
"Tabbing
set tabstop=8
set shiftwidth=4
set expandtab
set smarttab
set softtabstop=0

"
"Search
set incsearch
set hlsearch

"
"Statusline
" define 3 custom highlight groups
hi User1 ctermfg=white
hi User2 ctermfg=red
hi User3 ctermfg=lightgreen

set laststatus=2
set statusline=
set statusline+=%1*
set statusline+=%<\                     " indent
set statusline+=%3*%-5.40f\             " filename
set statusline+=%2*%H%M%R%W\            " statuses
set statusline+=%=%1*%y\                " filetype
set statusline+=%10((%l,%c)%)\          " row column
set statusline+=%P\                     " percentage

set noshowmode

"
"TabLine
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let wn = tabpagewinnr(i,'$')

            let s .= '%' . i . 'T'
            let s .= (i == t ? '%#TabNumSel#' : '%#TabNum#')
            let s .= i

            if wn > 1
                let s .= '.'
                let s .= (i == t ? '%#TabWinNumSel#' : '%#TabWinNum#')
                let s .= wn
            end

            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')

            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            let file = fnamemodify(file, ':p:t')

            if file == ''
                let file = '[No Name]'
            endif

            let s .= file
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        return s
    endfunction
    set stal=1
    set tabline=%!MyTabLine()
endif

hi TabLineSel ctermbg=darkgrey ctermfg=white term=none
hi TabWinNumSel ctermbg=darkgrey ctermfg=white term=none
hi TabNumSel ctermbg=darkgrey ctermfg=white term=none

hi TabLine cterm=none ctermbg=none ctermfg=white term=none
hi TabWinNum cterm=none ctermbg=none ctermfg=white term=none

hi TabLineFill cterm=none

"
"
set lazyredraw
set tabpagemax=15

"
"Move swap files to tmp 
set directory^=$HOME/.vim/tmp//

"
"Rm error Sound
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"
"Mapping
" Leader
let mapleader = " "
" Save
nno <F2> :w<CR>
ino <F2> <ESC>:w<CR>i

" C stuff
au Filetype c ino #i #include | ino #d #define

" Movement between tabs
nno <silent> <S-h> :tabfirst<CR>
nno <silent> <S-l> :tablast<CR>
nno <silent> <S-j> :tabp<CR>
nno <silent> <S-k> :tabn<CR>

" Negative Reinforcment
nno <Left> :echoe "Use h"<CR>
nno <Right> :echoe "Use l"<CR>
nno <Up> :echoe "Use k"<CR>
nno <Down> :echoe "Use j"<CR>

"
" Tags binds
"  New Tab find tag
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
"  Vertical Split tag
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" Toggle between number and relativenumber
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
"Force write with sudo
command! W w !sudo tee % > /dev/null

"
"Skeleton Files
augroup templates
  autocmd BufNewFile *.* silent! execute '0r ~/.vim/templates/skeleton.'.expand("<afile>:e")
augroup END
"Enable Project Specific vimrc
" this allows for project specific vimrc files
" eg ./project/.vimrc
set exrc
set secure
" I use local .vimrc to install plugins for specific projects
" with vim-plug this allows for easy project customisability

" Example Plugins
"call plug#begin('~/.vim/plugged')
"
"" Golden ratio window splitter
"Plug 'zhaocai/GoldenView'
"
"" Initialize the plugin system
"call plug#end()

