""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"          FILE:  colorRoller.vim
" Last Modified:  2012/12/21.
"        AUTHOR:  Yusuke Wtase <ywatase@gmail.com>
"       VERSION:  1.0
"       CREATED:  2012/12/21
"   DESCRIPTION:  
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let ColorRoller = {}
let ColorRoller.colors = [
   \'default',
   \'moss',
   \'jellybeans',
   \'mustang',
   \'softblue',
   \'tir_black',
   \'wombat256mod',
   \'yuroyoro256',
   \'molokai',
   \'desert256',
   \'mrkn256',
   \'wuye',
   \ ]
function! ColorRoller.change()
   let color = get(self.colors, 0)
   silent exe "colorscheme " . color
   redraw
   echo self.colors
endfunction
function! ColorRoller.roll()
   let item = remove(self.colors, 0)
   call insert(self.colors, item, len(self.colors))
   call self.change()
endfunction
function! ColorRoller.unroll()
   let item = remove(self.colors, -1)
   call insert(self.colors, item, 0)
   call self.change()
endfunction
nnoremap <silent><F9> : <C-u>call ColorRoller.roll()<CR>
nnoremap <silent><F8> : <C-u>call ColorRoller.unroll()<CR>
