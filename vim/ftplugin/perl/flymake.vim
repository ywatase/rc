""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"          FILE:  flymake.vim
" Last Modified:  2011/04/21.
"        AUTHOR:  Yusuke Watase (ym), ywatase@gmail.com
"       VERSION:  1.0
"       CREATED:  2010/04/22 12:28:48
"   DESCRIPTION:  flymake for perl. put this file to .vim/ftplugin/perl
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

function! RunMake ()
	if has('python')
python <<PYTHONEOF
import vim
import os
import re
filepath = vim.current.buffer.name
cmd = r'setlocal makeprg=perl'
m = re.compile("^(.*/(?:ext)?lib/)").match(filepath)
if m is not None:
	cmd += r'\ -I' + m.group(1)
else:
	m = re.compile("^(.*)/(?:t|scripts?|root)/").match(filepath)
	if m is not None:
		path = os.path.join(m.group(1), "lib")
		if os.path.isdir(path):
			cmd += r'\ -I' + path
cmd += r'\ -cw\ %\ 2>&1\ \\\|\ perl\ -pe\ \'/at\\s\(\\S\+\)\\sline\\s\(\\d+\)\/\;print\ \"\$1:\$2:\"\;\''
vim.command(cmd)
PYTHONEOF
	else
		setlocal makeprg=perl\ -cw\ %\ 2>&1\ \\\|\ perl\ -pe\ \'/at\\s\(\\S\+\)\\sline\\s\(\\d+\)\/\;print\ \"\$1:\$2:\"\;\'
	endif
	setlocal errorformat=%f:%l:%m
	make
endfunction

autocmd! BufWritePost <buffer> :call RunMake()
