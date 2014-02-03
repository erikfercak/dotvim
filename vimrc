" Forget VI it's <current year>!
set nocompatible
set encoding=utf-8

" Set backspace, same as set backspace=2
set backspace=indent,eol,start

" Backup and history settings
set nobackup
set nowritebackup
set noswapfile
set history=500 " keep 500 lines of command line history

" Search
set incsearch " do incremental searching
set hlsearch
set ignorecase
set smartcase
set scrolloff=3
set sidescrolloff=5

syntax on

let mapleader = ","
nnoremap <Leader><space> a<c-x><c-o>
" Clear search highlight
nnoremap <Leader>h :noh<cr>
" Delete trailing spaces
nnoremap <Leader>b :silent :%s/\s\+$//<cr>:noh<cr>``
" Close window
nnoremap <Leader>q :clo<cr>

" Load Vundle
if filereadable(expand("~/.vim/vundles.vim"))
    source ~/.vim/vundles.vim
endif

set ruler " show the cursor position all the time
if v:version >= 703
    set relativenumber
    set colorcolumn=90
endif

" tabs
set ts=4
set sw=4
set expandtab
set smarttab

" Colors and fonts
" colorscheme vividchalk
set guifont=Monaco:h12.00
set background=dark
silent! colorscheme solarized

" Nicer status line
set statusline=%F%m%r%h%w\ [%{&ff}/%Y]\ [%{getcwd()}]\ %{SyntasticStatuslineFlag()}%=[%04l,%04v][%p%%/%L]
set laststatus=2

" Use console dialogs
set guioptions+=c
set showcmd " display incomplete commands

" Toggle extra whitespace and ruler. Useful for console copy & paste
nmap <Leader>l :setlocal list!<CR>:set relativenumber!<CR>
set list listchars=tab:»·,trail:·,eol:¬

" Tab completion options
" (only complete to the longest unambiguous match, and show a menu)
set completeopt=menu,preview
set wildmode=list:longest,list:full
set complete=.,w

set cf " Confirm some operations
set clipboard+=unnamed  " Yanks go on clipboard instead.

" Mappings

inoremap <F1> <ESC> " No Help, please
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" map shift+cmd+left/right to tabs
" noremap <D-S-Left> gT
" noremap <D-S-Right> gt

" map window focus shortcuts
" noremap <C-h> <C-w>h
" noremap <C-j> <C-w>j
" noremap <C-l> <C-w>l
" noremap <C-k> <C-w>k

" insert base filename
" noremap <Leader>f i<C-R>=expand("%:t:r")<CR><ESC>
" noremap <Leader>F a<C-R>=expand("%:t:r")<CR><ESC>

for fpath in split(globpath('~/.vim/settings', '*.vim'), '\n')
    exe 'source' fpath
endfor
