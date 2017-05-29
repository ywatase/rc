""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"          FILE:  init.vim
" Last Modified:  2012/12/20.
"        AUTHOR:  Yusuke Wtase <ywatase@gmail.com>
"       VERSION:  1.0
"       CREATED:  2012/06/05
"   DESCRIPTION:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("b:did_perl_init_ftplugin")
	finish
endif
let b:did_perl_init_ftplugin = 1

""""""""""""""""""""""""""""""
" keymap
""""""""""""""""""""""""""""""
map     <buffer>  <silent>  ,ry   :call Perl_Perltidy("n")<CR>
vmap    <buffer>  <silent>  ,ry   <C-C>:call Perl_Perltidy("v")<CR>
"noremap <buffer>  <silent>  ,rs   :call Perl_Source()<CR>
noremap <buffer>  <silent>  ,rs   :Perlsource<CR>
noremap <buffer>  <silent>  ,rp   :Perldoc<CR>

""""""""""""""""""""""""""""""
" ref.vim
""""""""""""""""""""""""""""""
" use perl.vim
let g:ref_no_default_key_mappings = 1

""""""""""""""""""""""""""""""
" setting
""""""""""""""""""""""""""""""
setlocal iskeyword+=:
setlocal smartindent expandtab

function! Perl_Tidy()
	setlocal makeprg=perl\ -cw\ %\ 2>&1\ \\\|\ perl\ -pe\ \'/at\\s\(\\S\+\)\\sline\\s\(\\d+\)\/\;print\ \"\$1:\$2:\"\;'
	setlocal efm=%f:%l:%m
endfunction
function! PerlSyntaxCheck()
	setlocal makeprg=perl\ -cw\ %\ 2>&1\ \\\|\ perl\ -pe\ \'/at\\s\(\\S\+\)\\sline\\s\(\\d+\)\/\;print\ \"\$1:\$2:\"\;'
	setlocal efm=%f:%l:%m
endfunction

" like EDITOR=vim perldoc -m modules
function! Perl_Source ()
	let l:item=expand("<cword>")
	let l:command="perldoc -l " . l:item
	echo l:command
	let l:path = system(l:command)
	if filereadable(l:path)
		execute "split" fnameescape(l:path)
	else
		echo l:path . " is not readable"
	endif
endfunction

call PerlSyntaxCheck()


"===  IMPORT FROM perl-support.vim =============================================
let s:Perl_PerltidyBackup			     = "no"
let s:Perl_perltidy_startscript_executable = 'no'
let s:Perl_perltidy_module_executable      = 'no'
"===  FUNCTION  ================================================================
"          NAME:  Perl_Perltidy
"   DESCRIPTION:  run perltidy(1) as a compiler
"    PARAMETERS:  mode - n:normal / v:visual
"       RETURNS:
"===============================================================================
function! Perl_Perltidy (mode)

  let Sou   = expand("%")               " name of the file in the current buffer
	if   (&filetype != 'perl') &&
				\ ( a:mode != 'v' || input( "'".Sou."' seems not to be a Perl file. Continue (y/n) : " ) != 'y' )
		echomsg "'".Sou."' seems not to be a Perl file."
		return
	endif
  "
  " check if perltidy start script is executable
  "
  if s:Perl_perltidy_startscript_executable == 'no'
    if !executable("perltidy")
      echohl WarningMsg
      echo 'perltidy does not exist or is not executable!'
      echohl None
      return
    else
      let s:Perl_perltidy_startscript_executable  = 'yes'
    endif
  endif
  "
  " check if perltidy module is executable
  " WORKAROUND: after upgrading Perl the module will no longer be found
  "
  if s:Perl_perltidy_module_executable == 'no'
    let perltidy_version = system("perltidy -v")
    if match( perltidy_version, 'copyright\c' )      >= 0 &&
    \  match( perltidy_version, 'Steve\s\+Hancock' ) >= 0
      let s:Perl_perltidy_module_executable = 'yes'
    else
      echohl WarningMsg
      echo 'The module Perl::Tidy can not be found! Please reinstall perltidy.'
      echohl None
      return
    endif
  endif
	"
  " ----- normal mode ----------------
  if a:mode=="n"
    if Perl_Input("reformat whole file [y/n/Esc] : ", "y", '' ) != "y"
      return
    endif
    if s:Perl_PerltidyBackup == 'yes'
    	exe ':write! '.Sou.'.bak'
		endif
    silent exe  ":update"
    let pos1  = line(".")
    exe '%!perltidy'
    exe ':'.pos1
    echo 'File "'.Sou.'" reformatted.'
  endif
  " ----- visual mode ----------------
  if a:mode=="v"
    let pos1  = line("'<")
    let pos2  = line("'>")
		if s:Perl_PerltidyBackup == 'yes'
			exe pos1.','.pos2.':write! '.Sou.'.bak'
		endif
    silent exe pos1.','.pos2.'!perltidy'
    echo 'File "'.Sou.'" (lines '.pos1.'-'.pos2.') reformatted.'
  endif
  "
  if v:shell_error
    echohl WarningMsg
    echomsg 'perltidy reported error code '.v:shell_error.' !'
    echohl None
  endif
	"
  if filereadable("perltidy.ERR")
    echohl WarningMsg
    echo 'Perltidy detected an error when processing file "'.Sou.'". Please see file perltidy.ERR'
    echohl None
  endif
  "
endfunction   " ---------- end of function  Perl_Perltidy  ----------
"===  FUNCTION  ================================================================
"          NAME:  Perl_Input
"   DESCRIPTION:  Input after a highlighted prompt
"    PARAMETERS:  prompt - prompt
"                 text   - default reply
"                 ...    - completion (optional)
"       RETURNS:
"===============================================================================
function! Perl_Input ( prompt, text, ... )
	echohl Search											" highlight prompt
	call inputsave()										" preserve typeahead
	if a:0 == 0 || empty(a:1)
		let retval	=input( a:prompt, a:text )
	else
		let retval	=input( a:prompt, a:text, a:1 )
	endif
	call inputrestore()										" restore typeahead
	echohl None												" reset highlighting
	let retval  = substitute( retval, '^\s\+', "", "" )		" remove leading whitespaces
	let retval  = substitute( retval, '\s\+$', "", "" )		" remove trailing whitespaces
	return retval
endfunction    " ----------  end of function Perl_Input ----------
