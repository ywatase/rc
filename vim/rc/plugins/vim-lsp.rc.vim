" vim: et ts=2 sts=2 sw=2
" 言語用Serverの設定


" デバッグ用設定
let g:lsp_log_verbose = 0  " デバッグ用ログを出力: 有効:1 無効:
let g:lsp_log_file = expand('~/.cache/tmp/vim-lsp.log')  " ログ出力のPATHを設定

let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1
let g:asyncomplete_popup_delay = 200
let g:lsp_text_edit_enabled = 1

let g:lsp_settings = {
      \  'perl-languageserver': {
      \    'disabled': 0,
      \   },
      \  'yaml-language-server': {
      \    'workspace_config': {
      \      'yaml': {
      \        'schemas': {
      \          'https://mattn.github.io/efm-langserver/schema.json': '/efm-langserver/config.yaml',
      \          'https://raw.githubusercontent.com/SchemaStore/schemastore/master/src/api/json/catalog.json': '/cf.yml',
      \        },
      \        'completion': v:true,
      \        'hover': v:true,
      \        'validate': v:true,
      \        'customTags': [
      \          '!Ref',
      \          '!Sub',
      \          '!Sub sequence',
      \          '!GetAtt',
      \          '!GetAZs',
      \          '!If',
      \          '!If sequence',
      \          '!Equals',
      \          '!Equals sequence',
      \          '!Not',
      \          '!Not sequence',
      \          '!And',
      \          '!And sequence',
      \          '!Or',
      \          '!Or sequence',
      \          '!FindInMap',
      \          '!FindInMap sequence',
      \          '!Join',
      \          '!Join sequence',
      \          '!Select',
      \          '!Select sequence',
      \          '!Split',
      \          '!Split sequence',
      \          '!ImportValue',
      \          '!Base64',
      \          '!Base64 mapping',
      \          '!Cidr',
      \          '!Cidr sequence',
      \          '!ImportValue'
      \        ],
      \      },
      \    },
      \  },
      \}

augroup MyLsp
  autocmd!

  if executable('pyls')
    " Python用の設定を記載
    " workspace_configで以下の設定を記載
    " - pycodestyleの設定はALEと重複するので無効にする
    " - jediの定義ジャンプで一部無効になっている設定を有効化
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': {server_info->['pyls']},
          \ 'whitelist': ['python'],
          \ 'workspace_config': {'pyls': {'plugins': {
          \   'pycodestyle': {'enabled': v:true},
          \   'pydocstyle': {'enabled': v:false},
          \   'pylint': {'enabled': v:false},
          \   'flake8': {'enabled': v:true},
          \   'isort':  {'enabled': v:true},
          \   'black':  {'enabled': v:true},
          \   'jedi_definition': {
          \     'follow_imports': v:true,
          \     'follow_builtin_imports': v:true,
          \   },
          \ }}}
          \ })
  endif

  autocmd FileType dockerfile call s:configure_lsp()
  autocmd FileType python call s:configure_lsp()
  autocmd FileType sh call s:configure_lsp()
  autocmd FileType go call s:configure_lsp()
  autocmd FileType tf call s:configure_lsp()

augroup END
" 言語ごとにServerが実行されたらする設定を関数化
function! s:configure_lsp() abort
  setlocal omnifunc=lsp#complete   " オムニ補完を有効化
  " LSP用にマッピング
  nnoremap <Plug>(my-lsp) <Nop>
  nmap <Leader>l <Plug>(my-lsp)
  nnoremap <buffer> <C-]> :<C-u>LspDefinition<CR>
  nnoremap <buffer> <plug>(my-lsp)c :<C-u>LspCodeAction<CR>
  nnoremap <buffer> <plug>(my-lsp)d :<C-u>LspDefinition<CR>
  nnoremap <buffer> <plug>(my-lsp)D :<C-u>LspReferences<CR>
  nnoremap <buffer> <plug>(my-lsp)s :<C-u>LspDocumentSymbol<CR>
  nnoremap <buffer> <plug>(my-lsp)S :<C-u>LspWorkspaceSymbol<CR>
  nnoremap <buffer> <plug>(my-lsp)Q :<C-u>LspDocumentFormat<CR>
  vnoremap <buffer> <plug>(my-lsp)Q :LspDocumentRangeFormat<CR>
  nnoremap <buffer> <plug>(my-lsp)K :<C-u>LspHover<CR>
  nnoremap <buffer> <F1> :<C-u>LspImplementation<CR>
  nnoremap <buffer> <F2> :<C-u>LspRename<CR>

  nnoremap <buffer> <Leader>ry :<C-u>LspDocumentFormat<CR>
  vnoremap <buffer> <Leader>ry <C-C>:LspDocumentFormat<CR>
  nnoremap <buffer> <Leader>rp :<C-u>LspDefinition<CR>
  vnoremap <buffer> <Leader>rp <C-C>:LspDefinition<CR>
  nnoremap <buffer> <Leader>rP :<C-u>LspPeekDefinition<CR>
  vnoremap <buffer> <Leader>rP <C-C>:LspPeekDefinition<CR>
  nnoremap <buffer> <Leader>rs :<C-u>LspDocumentSymbol<CR>
  vnoremap <buffer> <Leader>rs <C-C>:LspDocumentSymbol<CR>

  " snippet
  inoremap <expr> <Tab> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
  snoremap <expr> <Tab> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"

endfunction
