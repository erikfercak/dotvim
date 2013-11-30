#!/bin/bash

pushd `pwd`
git clone https://github.com/vim-php/phpctags ~/.vim/bin/phpctags
cd ~/.vim/phpctags && make
popd

mkdir ~/.vim/spell
wget http://ftp.vim.org/vim/runtime/spell/sk.utf-8.spl ~/.vim/spell/sk.utf-8.spl
wget http://ftp.vim.org/vim/runtime/spell/cs.utf-8.spl ~/.vim/spell/cs.utf-8.spl

git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vim --noplugin -u ~/.vim/vundles.vim -N "+set hidden" "+syntax on" +BundleClean! +BundleInstall +qall
ln -snf ~/.vim/vimrc ~/.vimrc
