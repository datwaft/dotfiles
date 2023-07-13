unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

syntax on
filetype plugin indent on

set mouse=a
set nocompatible
set backspace=indent,eol,start
set relativenumber
set number
set shiftwidth=2
set tabstop=2
set softtabstop=-1
set expandtab
set nowritebackup
set noswapfile
set linebreak
set breakindent
set breakindentopt=shift:2
set showbreak=↳\ 
set undodir=~/.vim/undo
set undofile
set wildmenu
set wildcharm=<tab>
set noshowmode
set list
set listchars=trail:·,tab:→\ ,nbsp:·
set incsearch
set termguicolors

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

silent! colorscheme catppuccin_mocha

let g:oscyank_silent = 1
autocmd TextYankPost *
    \ if v:event.operator is 'y' && v:event.regname is '+' |
    \ execute 'OSCYankRegister +' |
    \ endif
