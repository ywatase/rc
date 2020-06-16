" vim: et ts=2 sts=2 sw=2
" 言語用Serverの設定
augroup MyLsp
  " デバッグ用設定
  let g:lsp_log_verbose = 1  " デバッグ用ログを出力
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
        \  'yaml-language-server1': {
        \    'workspace_config': {
        \      'yaml': {
        \        'schemas': {
        \          'https://mattn.github.io/efm-langserver/schema.json': '/efm-langserver/config.yaml'
        \        },
        \        'completion': v:true,
        \        'hover': v:true,
        \        'validate': v:true,
        \      }
        \    }
        \  },
        \}



  if executable('pyls')
    " Python用の設定を記載
    " workspace_configで以下の設定を記載
    " - pycodestyleの設定はALEと重複するので無効にする
    " - jediの定義ジャンプで一部無効になっている設定を有効化
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'pyls',
          \ 'cmd': { server_info -> ['pyls'] },
          \ 'whitelist': ['python'],
          \ 'workspace_config': {'pyls': {'plugins': {
          \   'pycodestyle': {'enabled': v:false},
          \   'jedi_definition': {'follow_imports': v:true, 'follow_builtin_imports': v:true},}}}
          \})
  endif

  autocmd FileType dockerfile call s:configure_lsp()
  autocmd FileType python call s:configure_lsp()
  autocmd FileType sh call s:configure_lsp()

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
endfunction
