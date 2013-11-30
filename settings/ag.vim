if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Map search shortcuts
  nnoremap <Leader>a :Ag! <cword><cr>
  nnoremap <Leader>af :Ag! "function <cword>"<cr>
  nnoremap <Leader>ac :Ag! "class <cword>"<cr>
  nnoremap <Leader>ai :Ag! "interface <cword>"<cr>
endif
