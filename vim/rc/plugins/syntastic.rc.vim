""""""""""""""""""""""""""""""
" syntastic
""""""""""""""""""""""""""""""
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_perl_checkers=['perl', 'perlcritic', 'podchecker']
let g:syntastic_rubp_checkers=['rubocop']
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_cpanfile_checkers = ['cpanfile', 'perl']
let g:syntastic_enable_perl_checker = 1
let g:syntastic_debug = 0
let g:syntastic_mode_map = {
  \ "mode": "active",
  \ "active_filetypes": ["ruby", "perl"],
  \ "passive_filetypes": ["vim", 'go', 'cpanfile'] }

" Issue with vim-go and syntastic is that the location list window that contains
" the output of commands such as :GoBuild and :GoTest might not appear.
" To resolve this:
let g:go_list_type = "quickfix"
