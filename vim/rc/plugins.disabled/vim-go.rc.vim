nnoremap <Plug>(my-go) <Nop>
" ide
nmap <Leader>i <Plug>(my-go)
autocmd FileType go nmap <Plug>(my-go)r  <Plug>(go-run)
autocmd FileType go nmap <Plug>(my-go)b  <Plug>(go-build)
autocmd FileType go nmap <Plug>(my-go)t  <Plug>(go-test)
autocmd FileType go nmap <Plug>(my-go)c  <Plug>(go-coverage)
autocmd FileType go nmap <Plug>(my-go)ds <Plug>(go-def-split)
autocmd FileType go nmap <Plug>(my-go)dv <Plug>(go-def-vertical)
autocmd FileType go nmap <Plug>(my-go)dt <Plug>(go-def-tab)
autocmd FileType go nmap <Plug>(my-go)do <Plug>(go-doc)
autocmd FileType go nmap <Plug>(my-go)v <Plug>(go-doc-vertical)
autocmd FileType go nmap <Plug>(my-go)b <Plug>(go-doc-browser)
autocmd FileType go nmap <Plug>(my-go)i <Plug>(go-imports)
autocmd FileType go nmap <Plug>(my-go)s <Plug>(go-implements)
autocmd FileType go nmap <Plug>(my-go)i <Plug>(go-info)
autocmd FileType go nmap <Plug>(my-go)e <Plug>(go-rename)

" Below are some settings you might find useful. For the full list see :he go-settings.
" By default syntax-highlighting for Functions, Methods and Structs is disabled. To change it:
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" Enable goimports to automatically insert import paths instead of gofmt:
let g:go_fmt_command = "goimports"

let g:go_def_mapping_enabled = 0
let g:go_doc_keywordprg_enabled = 0
