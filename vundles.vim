" Run vundle update by issuing command line with the following syntax:
" vim --noplugin -u ~/.vim/vundles.vim -N "+set hidden" "+syntax on" +BundleClean! +BundleInstall +qall

" Filetype off is required by vundle
filetype off

set rtp+=~/.vim/bundle/vundle/
let $GIT_SSL_NO_VERIFY = 'true'

call vundle#rc()
Plugin 'gmarik/vundle'
Plugin 'itchyny/lightline.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'kien/ctrlp.vim'
Plugin 'tomtom/tcomment_vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/matchit.zip'
Plugin 'junegunn/vim-easy-align'
Plugin 'dense-analysis/ale'
Plugin 'vim-ruby/vim-ruby'
Plugin 'hashivim/vim-terraform'

"Filetype plugin indent on is required by vundle
filetype plugin indent on
