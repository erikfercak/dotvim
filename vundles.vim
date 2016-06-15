" Run vundle update by issuing command line with the following syntax:
" vim --noplugin -u ~/.vim/vundles.vim -N "+set hidden" "+syntax on" +BundleClean! +BundleInstall +qall

" Filetype off is required by vundle
filetype off

set rtp+=~/.vim/bundle/vundle/
let $GIT_SSL_NO_VERIFY = 'true'

call vundle#rc()
Plugin 'gmarik/vundle'
Plugin 'bling/vim-airline'
Plugin 'altercation/vim-colors-solarized'
Plugin 'joonty/vdebug'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/syntastic'
Plugin 'shawncplus/phpcomplete.vim'
Plugin 'tomtom/tcomment_vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/AutoTag'
Plugin 'vim-scripts/matchit.zip'
Plugin 'vim-php/tagbar-phpctags.vim'
Plugin 'blueyed/smarty.vim'
Plugin 'rizzatti/dash.vim'
Plugin 'SirVer/ultisnips'
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-projectionist'
Plugin 'junegunn/vim-easy-align'

"Filetype plugin indent on is required by vundle
filetype plugin indent on
