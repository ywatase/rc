""""""""""""""""""""""""""""""
" ref.vim
""""""""""""""""""""""""""""""
let g:ref_source_webdict_sites = {
            \ 'wiktionary': {
            \ 'url': 'http://ja.wiktionary.org/wiki/%s',
            \ 'keyword_encoding': 'utf-8',
            \ 'cache': 1,
            \ },
            \ 'wikipedia:ja':{
            \ 'url': 'http://ja.wikipedia.org/wiki/%s',
            \ 'keyword_encoding': 'utf-8',
            \ 'cache': 1,
            \ },
            \ 'alc':{
            \ 'url': 'http://eow.alc.co.jp/%s/UTF-8/',
            \ 'keyword_encoding': 'utf-8',
            \ 'cache': 1,
            \ }
            \ }

" 出力に対するフィルタ。最初の数行を削除している。
func! g:ref_source_webdict_sites.wiktionary.filter(output)
    return join(split(a:output, "\n")[18 :], "\n")
endf
func! g:ref_source_webdict_sites.alc.filter(output)
    return join(split(a:output, "\n")[34 :], "\n")
endf

let g:ref_source_webdict_sites.default = 'alc'
nmap <F12> :Ref webdict<space>
