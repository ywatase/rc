""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"          FILE:  colorRoller.vim
" Last Modified:  2012/12/23.
"        AUTHOR:  Yusuke Wtase <ywatase@gmail.com>
"       VERSION:  1.0
"       CREATED:  2012/12/21
"   DESCRIPTION:  
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:colorroller_default_colors = [
			\ 'default',
			\ 'blue',
			\ 'darkblue',
			\ 'delek',
			\ 'desert',
			\ 'elflord',
			\ 'evening',
			\ 'koehler',
			\ 'morning',
			\ 'murphy',
			\ 'pablo',
			\ 'peachpuff',
			\ 'ron',
			\ 'shine',
			\ 'slate',
			\ 'torte',
			\ 'zellner',
			\ ]
let s:colors = exists('g:colorroller_colors') ? g:colorroller_colors : s:colorroller_default_colors

function! colorRoller#change()
   let color = get(s:colors, 0)
   silent exe "colorscheme " . color
   redraw
   echo s:colors
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
