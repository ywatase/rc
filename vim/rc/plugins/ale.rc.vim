" flake8をLinterとして登録
let g:ale_linters = {
    \ 'python': ['flake8'],
    \ 'markdown': ['prettier'],
    \ }
" 各ツールをFixerとして登録
let g:ale_fixers = {
    \ 'python': ['autopep8', 'isort'],
    \ 'markdown': ['prettier'],
    \ 'yaml': ['prettier'],
    \ }

let g:ale_python_autopep8_options = '--aggressive --aggressive'

" ファイル保存時に自動的にFixするオプションもあるのでお好みで
let g:ale_fix_on_save = 1
