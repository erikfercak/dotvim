nnoremap <Leader>t :CtrlP<cr>
nnoremap <Leader>b :CtrlPBuffer<cr>
nnoremap <Leader>r :CtrlPMRUFiles<cr>
nnoremap <Leader>b :CtrlPBuffer<cr>

" Mimic Command-T behaviour
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_clear_cache_on_exit=0

if executable('rg')
  " Use rg in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'rg --files --color=never %s'
endif
