""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"          FILE:  <+FILE NAME+>
" Last Modified:  2011/09/18.
"        AUTHOR:  <+AUTHOR+> <<+EMAIL+>>
"       VERSION:  1.0
"       CREATED:  <+DATE+>
"   DESCRIPTION:  
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Only do this when not done yet for this buffer
if exists("b:did_<+FILE NAME+>_ftplugin")
	finish
endif
let b:did_<+FILE NAME+>_ftplugin = 1

function! RunMake ()
	if has('python')
python <<PYTHONEOF
import vim
import os
import re
filepath = vim.current.buffer.name
cmd = r'setlocal makeprg=perl'
m = re.compile("^(.*)/t/").match(filepath)
if m is not None:
	path = os.path.join(m.group(1), "lib")
	if os.path.isdir(path):
			cmd += r'\ -I' + path
	path = os.path.join(m.group(1), "t", "lib")
	if os.path.isdir(path):
		cmd += r'\ -I' + path
else:
	m = re.compile("^(.*)/(?:(?:ext)?lib|bin|scripts?|root)/").match(filepath)
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
