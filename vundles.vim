" Run vundle update by issuing command line with the following syntax:
" vim --noplugin -u ~/.vim/vundles.vim -N "+set hidden" "+syntax on" +BundleClean! +BundleInstall +qall

" Filetype off is required by vundle
filetype off

set rtp+=~/.vim/bundle/vundle/
let $GIT_SSL_NO_VERIFY = 'true'

call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'altercation/vim-colors-solarized'
Bundle "AndrewRadev/splitjoin.vim"
Bundle 'git://repo.or.cz/vcscommand'
Bundle 'joonty/vdebug'
Bundle 'kien/ctrlp.vim'
Bundle 'majutsushi/tagbar'
Bundle 'msanders/snipmate.vim'
Bundle 'rking/ag.vim'
Bundle 'scrooloose/syntastic'
Bundle 'shawncplus/phpcomplete.vim'
Bundle 'tomtom/tcomment_vim'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'vim-scripts/AutoTag'
Bundle 'vim-scripts/matchit.zip'
Bundle 'vim-php/tagbar-phpctags.vim'

"Filetype plugin indent on is required by vundle
filetype plugin indent on
