""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"          FILE:  colorRoller.vim
" Last Modified:  2012/12/23.
"        AUTHOR:  Yusuke Wtase <ywatase@gmail.com>
"       VERSION:  1.0
"       CREATED:  2012/12/21
"   DESCRIPTION:  
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! colorRoller#defaults()
	let s:colorroller_default_colors = uniq(sort(map(split(globpath(&rtp, "colors/*.vim"), "\n"), "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')")))
	let s:colorroller_toggler = 'all'
	let s:colors = uniq(sort(exists('g:colorroller_colors') ? g:colorroller_colors : s:colorroller_default_colors))
endfunction
function! colorRoller#all()
	let s:colorroller_toggler = 'defaults'
	let s:colors = s:colorroller_default_colors
endfunction
function! colorRoller#toggle()
	call colorRoller#{s:colorroller_toggler}()
	echo s:colors
endfunction

function! colorRoller#change()
   let color = get(s:colors, 0)
   silent exe "colorscheme " . color
   redraw
   echo s:colors
endfunction
function! colorRoller#reset()
	call colorRoller#default()
endfunction
function! colorRoller#roll()
   let item = remove(s:colors, 0)
   call insert(s:colors, item, len(s:colors))
   call colorRoller#change()
endfunction
function! colorRoller#unroll()
   let item = remove(s:colors, -1)
   call insert(s:colors, item, 0)
   call colorRoller#change()
endfunction

call colorRoller#defaults()
