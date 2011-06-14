#!/bin/bash

ln -s ~/.vim/.vimrc ~/.vimrc

cd ~/.vim
git submodule init
env GIT_SSL_NO_VERIFY=true git submodule update

