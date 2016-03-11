if has("unix")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
        " Close window
        nnoremap <Leader>d :Dash<cr>
    endif
endif

