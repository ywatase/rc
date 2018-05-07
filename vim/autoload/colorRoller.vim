""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"          FILE:  colorRoller.vim
" Last Modified:  2012/12/23.
"        AUTHOR:  Yusuke Wtase <ywatase@gmail.com>
"       VERSION:  1.0
"       CREATED:  2012/12/21
"   DESCRIPTION:  
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! colorRoller#colors ()
	let s:colorroller_default_colors = split(globpath(&rtp, "colors/*.vim"), "\n")
	let s:colors = map(exists('g:colorroller_colors') ? g:colorroller_colors : s:colorroller_default_colors, "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')")
endfunc

function! colorRoller#change()
   let color = get(s:colors, 0)
   silent exe "colorscheme " . color
   redraw
   echo s:colors
endfunction
function! colorRoller#reset()
	call colorRoller#colors()
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

call colorRoller#colors()
