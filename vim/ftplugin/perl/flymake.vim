""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"          FILE:  flymake.vim
" Last Modified:  2011/09/29.
"        AUTHOR:  Yusuke Watase (ym), ywatase@gmail.com
"       VERSION:  1.0
"       CREATED:  2010/04/22 12:28:48
"   DESCRIPTION:  flymake for perl. put this file to .vim/ftplugin/perl
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Only do this when not done yet for this buffer
if exists("b:did_flymake_ftplugin")
	finish
endif
let b:did_flymake_ftplugin = 1

function! RunMake ()
	let l:include_path = []
	let l:result = matchstr(expand('%:p'), '^.\{-}\%(/t/\%(lib/t/\)\?\)\@=')
	if l:result != ""
		let l:dir = simplify(l:result . '/lib')
		if isdirectory(l:dir)
			call add(l:include_path, l:dir)
		endif 
		let l:dir = simplify(l:result . '/t/lib')
		if isdirectory(l:dir)
			call add(l:include_path, l:dir)
		endif 
	else
		let l:result = matchstr(expand('%:p'), '^.*/\%(\%(ext\)\?lib\|bin\|scripts\?\|root\)\@=')
		if l:result != ""
			let l:dir = simplify(l:result . '/lib')
			if isdirectory(l:dir)
				call add(l:include_path, l:dir)
			endif 
		endif
	endif
	let l:cmd_parse_result = 'perl -pe '. "'" . '/at\s(\S+)\sline\s(\d+)/;print qq{$1:$2:};' . "'"
	execute ':setlocal makeprg=' . escape('perl ' . join(map(copy(l:include_path), '"-I ".v:val'),' ') . ' -cw % 2>&1 \| ' . l:cmd_parse_result , ' \();$|')
	execute ':setlocal path='. join(add(map(copy(l:include_path), 'escape(v:val, " ,")'), &l:path), ',')
	setlocal errorformat=%f:%l:%m
	make
endfunction

autocmd! BufWritePost <buffer> :call RunMake()
