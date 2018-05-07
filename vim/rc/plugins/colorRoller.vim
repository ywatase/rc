" See ~/.vim/autoload/colorRoller.vim
nnoremap <silent><F9> : <C-u>call colorRoller#roll()<CR>
nnoremap <silent><S-F9> : <C-u>call colorRoller#unroll()<CR>
nnoremap <silent><F8> : <C-u>call colorRoller#toggle()<CR>

let g:colorroller_colors = [
			\ 'darkblue',
			\ 'jellybeans',
			\ 'koehler',
			\ 'mrkn256',
			\ 'solarized',
			\ 'tender',
			\ ]

