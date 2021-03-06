if !has('gui_running')
  set t_Co=256
endif
let g:lightline = {
    \ 'colorscheme' : 'solarized',
    \ 'active': {
    \   'left':  [ [ 'mode', 'paste' ],
	\              [ 'ftfffe', 'fugitive', 'filename' ],
    \              [ 'charcode' ] ],
    \   'right': [ [ 'lineinfo', 'percent' ] ]
    \   },
    \ 'component' : {
    \   'charcode' : '0x%B(%b)'
    \  },
    \ 'component_function': {
    \   'mode'        : 'MyMode',
    \   'modified'    : 'MyModified',
    \   'readonly'    : 'MyReadonly',
    \   'fugitive'    : 'MyFugitive',
    \   'ftfffe'      : 'MyFtFfFe',
    \   'filename'    : 'MyFilename',
    \   },
    \ }
func! MyModified()
	return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '[+]' : &modifiable ? '' : '[-]'
endf

func! MyReadonly()
	return &ft !~? 'help\|vimfiler\|gundo' && &ro ? '[RO]' : ''
endf
func! MyFilename()
	return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
				\ (&ft == 'vimfiler' ? vimfiler#get_status_string() : 
				\  &ft == 'unite' ? unite#get_status_string() : 
				\  &ft == 'vimshell' ? substitute(b:vimshell.current_dir,expand('~'),'~','') : 
				\ '' == expand('%t') ? '[No Name]' : expand('%t')) .
				\ ('' != MyModified() ? ' ' . MyModified() : '')
endf
func! MyFugitive()
  return &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head') && strlen(fugitive#head()) ? '(' . fugitive#head() . ')' : ''
endf
func! MyFiletype()
  return '[' . (strlen(&filetype) ? &filetype : 'no ft') . ']'
endf
func! MyMode()
	return winwidth('.') > 60 ? lightline#mode() : ''
endf
func! MyFtFfFe()
	return winwidth('.') > 60 ? (MyFiletype() . MyFfFe()) : ''
endf
