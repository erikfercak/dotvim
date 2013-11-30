" Tagbar
if executable('/usr/local/bin/ctags')
    let g:tabgbar_ctags_bin = '/usr/local/bin/ctags'
elseif executable('/usr/bin/ctags')
    let g:tabgbar_ctags_bin = '/usr/bin/ctags'
endif

noremap <Leader>T :TagbarToggle<CR>
