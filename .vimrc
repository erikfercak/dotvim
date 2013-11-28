" Forget VI it's <current year>!
set nocompatible
set encoding=utf-8

" Set backspace, same as set backspace=2
set backspace=indent,eol,start

filetype off
set rtp+=~/.vim/bundle/vundle/
let $GIT_SSL_NO_VERIFY = 'true'
call vundle#rc()
Bundle 'Janiczek/vim-latte'
Bundle 'gmarik/vundle'
Bundle 'altercation/vim-colors-solarized'
Bundle 'git://repo.or.cz/vcscommand'
Bundle 'kien/ctrlp.vim'
Bundle 'rking/ag.vim'
Bundle 'msanders/snipmate.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-vividchalk'
Bundle 'vim-scripts/L9'
Bundle 'vim-scripts/matchit.zip'
Bundle 'scrooloose/syntastic'
Bundle 'ervandew/supertab'
Bundle 'shawncplus/phpcomplete.vim'
Bundle 'PDV--phpDocumentor-for-Vim'

filetype plugin indent on

" Backup and history settings

set nobackup
set nowritebackup
set history=50 " keep 50 lines of command line history

" Search
set incsearch " do incremental searching
set hlsearch
set ignorecase
set smartcase
set scrolloff=3
set sidescrolloff=5

let mapleader = ","
nnoremap <Leader><space> a<c-x><c-o>
" Clear search highlight
nnoremap <Leader>h :noh<cr>
" Delete trailing spaces
nnoremap <Leader>b :silent :%s/\s\+$//<cr>:noh<cr>``
" Close window
nnoremap <Leader>q :clo<cr>

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " Map search shortcuts
  nnoremap <Leader>a :Ag! <cword><cr>
  nnoremap <Leader>af :Ag! "function <cword>"<cr>
  nnoremap <Leader>ac :Ag! "class <cword>"<cr>
  nnoremap <Leader>ai :Ag! "interface <cword>"<cr>
endif

" Syntastic
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [], 'passive_filetypes': [] }
map <F9> :SyntasticCheck<CR>

" CtrlP
nnoremap <Leader>t :CtrlP<cr>
" Mimic Command-T behaviour
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_clear_cache_on_exit=0

" Go fullscreen
if has("gui_running")
    set fu
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
colorscheme solarized

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

set cf  " Enable error files & error jumping.
set clipboard+=unnamed  " Yanks go on clipboard instead.

syntax enable
au FileType php set omnifunc=phpcomplete


" Mappings

inoremap <F1> <ESC> " No Help, please
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" reindent whole file
noremap <F11> 1G=G``

" map shift+cmd+left/right to tabs
noremap <D-S-Left> gT
noremap <D-S-Right> gt

" map window focus shortcuts
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-l> <C-w>l
noremap <C-k> <C-w>k

" insert base filename
noremap <Leader>f i<C-R>=expand("%:t:r")<CR><ESC>
noremap <Leader>F a<C-R>=expand("%:t:r")<CR><ESC>

" Set tabstop, softtabstop and shiftwidth to the same value
" Originally from http://vimcasts.org/episodes/tabs-and-spaces/
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif

  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

map <Leader>s :Stab<cr>

let g:SuperTabDefaultCompletionType = "context"
