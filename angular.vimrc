" Project Plugins
call plug#begin('~/.vim/plugged')
" Typescrript syntax support
Plug 'https://github.com/leafgarland/typescript-vim'

" Javascript syntax highlighting
Plug 'https://github.com/pangloss/vim-javascript'

" TS features plugin
Plug 'https://github.com/Quramy/tsuquyomi'

" Syntastic plugin
Plug 'https://github.com/vim-syntastic/syntastic'

" Auto pairs plugin
Plug 'https://github.com/jiangmiao/auto-pairs'

" Angular CLI plugin
" Use :Ng command in Vim
Plug 'https://github.com/bdauria/angular-cli.vim'

" Initialize the plugin system
call plug#end()

" Enable displaying TS compilation errors in the QuickFix window
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" Syntastic syntax highlighting
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi']

" Angular CLI
autocmd FileType typescript,html call angular_cli#init()
