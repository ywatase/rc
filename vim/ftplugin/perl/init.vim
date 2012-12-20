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
map     <buffer>  <silent>  ,rc  :call Perl_Perlcritic()<CR>
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


let s:Perl_PerlcriticOptions     = ""
let s:Perl_PerlcriticSeverity    = 3
let s:Perl_PerlcriticVerbosity   = 5

let s:Perl_PerltidyBackup			     = "no"
let s:Perl_perltidy_startscript_executable = 'no'
let s:Perl_perltidy_module_executable      = 'no'

let g:Perl_FilenameEscChar 			= ' \%#[]'
let s:Perl_saved_global_option		= {}
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

"------------------------------------------------------------------------------
"  run : perlcritic     
"------------------------------------------------------------------------------
"
" All formats consist of 2 parts:
"  1. the perlcritic message format
"  2. the trailing    '%+A%.%#\ at\ %f\ line\ %l%.%#'
" Part 1 rebuilds the original perlcritic message. This is done to make
" parsing of the messages easier.
" Part 2 captures errors from inside perlcritic if any.
" Some verbosity levels are treated equal to give quickfix the filename.
"
" verbosity rebuilt
"
let s:PCverbosityFormat1 	= 1
let s:PCverbosityFormat2 	= 2
let s:PCverbosityFormat3 	= 3
let s:PCverbosityFormat4 	= escape( '"%f:%l:%c:%m.  %e  (Severity: %s)\n"', '%' )
let s:PCverbosityFormat5 	= escape( '"%f:%l:%c:%m.  %e  (Severity: %s)\n"', '%' )
let s:PCverbosityFormat6 	= escape( '"%f:%l:%m, near ' . "'%r'." . '  (Severity: %s)\n"', '%' )
let s:PCverbosityFormat7 	= escape( '"%f:%l:%m, near ' . "'%r'." . '  (Severity: %s)\n"', '%' )
let s:PCverbosityFormat8 	= escape( '"%f:%l:%c:[%p] %m. (Severity: %s)\n"', '%' )
let s:PCverbosityFormat9 	= escape( '"%f:%l:[%p] %m, near ' . "'%r'" . '. (Severity: %s)\n"', '%' )
let s:PCverbosityFormat10	= escape( '"%f:%l:%c:%m.\n  %p (Severity: %s)\n%d\n"', '%' )
let s:PCverbosityFormat11	= escape( '"%f:%l:%m, near ' . "'%r'" . '.\n  %p (Severity: %s)\n%d\n"', '%' )
"
" parses output for different verbosity levels:
"
let s:PCInnerErrorFormat	= ',\%+A%.%#\ at\ %f\ line\ %l%.%#'
let s:PCerrorFormat1 			= '%f:%l:%c:%m'         . s:PCInnerErrorFormat
let s:PCerrorFormat2 			= '%f:\ (%l:%c)\ %m'    . s:PCInnerErrorFormat
let s:PCerrorFormat3 			= '%m\ at\ %f\ line\ %l'. s:PCInnerErrorFormat
let s:PCerrorFormat4 			= '%f:%l:%c:%m'         . s:PCInnerErrorFormat
let s:PCerrorFormat5 			= '%f:%l:%c:%m'         . s:PCInnerErrorFormat
let s:PCerrorFormat6 			= '%f:%l:%m'            . s:PCInnerErrorFormat
let s:PCerrorFormat7 			= '%f:%l:%m'            . s:PCInnerErrorFormat
let s:PCerrorFormat8 			= '%f:%l:%m'            . s:PCInnerErrorFormat
let s:PCerrorFormat9 			= '%f:%l:%m'            . s:PCInnerErrorFormat
let s:PCerrorFormat10			= '%f:%l:%m'            . s:PCInnerErrorFormat
let s:PCerrorFormat11			= '%f:%l:%m'            . s:PCInnerErrorFormat
"===  FUNCTION  ================================================================
"          NAME:  Perl_Perlcritic
"   DESCRIPTION:  run perlcritic(1) liek a compiler
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! Perl_Perlcritic ()
  let l:currentbuffer = bufname("%")
  if &filetype != "perl"
    echohl WarningMsg | echo l:currentbuffer.' seems not to be a Perl file' | echohl None
    return
  endif
  if executable("perlcritic") == 0                  " not executable
    echohl WarningMsg | echo 'perlcritic not installed or not executable' | echohl None
    return
  endif
  let s:Perl_PerlcriticMsg = ""
  exe ":cclose"
  silent exe  ":update"
	"
	" check for a configuration file
	"
	let	perlCriticRcFile		= ''
	let	perlCriticRcFileUsed	= 'no'
	if exists("$PERLCRITIC")
		let	perlCriticRcFile	= $PERLCRITIC
	elseif filereadable( '.perlcriticrc' )
		let	perlCriticRcFile	= '.perlcriticrc'
	elseif filereadable( $HOME.'/.perlcriticrc' )
		let	perlCriticRcFile	= $HOME.'/.perlcriticrc'
	endif
	"
	" read severity and/or verbosity from the configuration file if specified
	"
	if perlCriticRcFile != ''
		for line in readfile(perlCriticRcFile)
			" default settings come before the first named block
			if line =~ '^\s*['
				break
			else
				let	list = matchlist( line, '^\s*severity\s*=\s*\([12345]\)' )
				if !empty(list)
					let s:Perl_PerlcriticSeverity	= list[1]
					let	perlCriticRcFileUsed	= 'yes'
				endif
				let	list = matchlist( line, '^\s*severity\s*=\s*\(brutal\|cruel\|harsh\|stern\|gentle\)' )
				if !empty(list)
					let s:Perl_PerlcriticSeverity	= index( s:PCseverityName, list[1] )
					let	perlCriticRcFileUsed	= 'yes'
				endif
				let	list = matchlist( line, '^\s*verbose\s*=\s*\(\d\+\)' )
				if !empty(list) && 1<= list[1] && list[1] <= 11
					let s:Perl_PerlcriticVerbosity	= list[1]
					let	perlCriticRcFileUsed	= 'yes'
				endif
			endif
		endfor
	endif
	" 
  let perlcriticoptions	=
		  \      ' -severity '.s:Perl_PerlcriticSeverity
      \     .' -verbose '.eval("s:PCverbosityFormat".s:Perl_PerlcriticVerbosity)
      \     .' '.escape( s:Perl_PerlcriticOptions, g:Perl_FilenameEscChar )
      \     .' '
	"
	call s:Perl_SaveGlobalOption('errorformat')
  exe  ':set errorformat='.eval("s:PCerrorFormat".s:Perl_PerlcriticVerbosity)
	call s:Perl_SaveGlobalOption('makeprg')
	set makeprg=perlcritic
  "
	silent exe ':make '.perlcriticoptions.fnameescape( expand("%:p") )
  "
	redraw!
  exe ":botright cwindow"
	call s:Perl_RestoreGlobalOption('errorformat')
	call s:Perl_RestoreGlobalOption('makeprg')
  "
  " message in case of success
  "
	let sev_and_verb	= 'severity '.s:Perl_PerlcriticSeverity.
				\				      ' ['.s:PCseverityName[s:Perl_PerlcriticSeverity].']'.
				\							', verbosity '.s:Perl_PerlcriticVerbosity
	"
	let rcfile	= ''
	if perlCriticRcFileUsed == 'yes'
		let rcfile	= " ( configcfile '".perlCriticRcFile."' )"
	endif
  if l:currentbuffer ==  bufname("%")
		let s:Perl_PerlcriticMsg	= l:currentbuffer.' :  NO CRITIQUE, '.sev_and_verb.' '.rcfile
  else
    setlocal wrap
    setlocal linebreak
		let s:Perl_PerlcriticMsg	= 'perlcritic : '.sev_and_verb.rcfile
  endif
	redraw!
  echohl Search | echo s:Perl_PerlcriticMsg | echohl None
endfunction   " ---------- end of function  Perl_Perlcritic  ----------
"
let s:PCseverityName	= [ "DUMMY", "brutal", "cruel", "harsh", "stern", "gentle" ]
let s:PCverbosityName	= [ '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11' ]

"===  FUNCTION  ================================================================
"          NAME:  Perl_PerlcriticSeverityList
"   DESCRIPTION:  perlcritic severity : callback function for completion
"    PARAMETERS:  ArgLead - 
"                 CmdLine - 
"                 CursorPos - 
"       RETURNS:  
"===============================================================================
function!	Perl_PerlcriticSeverityList ( ArgLead, CmdLine, CursorPos )
	return filter( copy( s:PCseverityName[1:] ), 'v:val =~ "\\<'.a:ArgLead.'\\w*"' )
endfunction    " ----------  end of function Perl_PerlcriticSeverityList  ----------

"===  FUNCTION  ================================================================
"          NAME:  Perl_PerlcriticVerbosityList
"   DESCRIPTION:  perlcritic verbosity : callback function for completion
"    PARAMETERS:  ArgLead - 
"                 CmdLine - 
"                 CursorPos - 
"       RETURNS:  
"===============================================================================
function!	Perl_PerlcriticVerbosityList ( ArgLead, CmdLine, CursorPos )
	return filter( copy( s:PCverbosityName), 'v:val =~ "\\<'.a:ArgLead.'\\w*"' )
endfunction    " ----------  end of function Perl_PerlcriticVerbosityList  ----------

"===  FUNCTION  ================================================================
"          NAME:  Perl_GetPerlcriticSeverity
"   DESCRIPTION:  perlcritic severity : used in command definition
"    PARAMETERS:  severity - perlcritic severity
"       RETURNS:  
"===============================================================================
function! Perl_GetPerlcriticSeverity ( severity )
	let s:Perl_PerlcriticSeverity = 3                         " the default
	let	sev	= a:severity
	let sev	= substitute( sev, '^\s\+', '', '' )  	     			" remove leading whitespaces
	let sev	= substitute( sev, '\s\+$', '', '' )	       			" remove trailing whitespaces
	"
	if sev =~ '^\d$' && 1 <= sev && sev <= 5
		" parameter is numeric
		let s:Perl_PerlcriticSeverity = sev
		"
	elseif sev =~ '^\a\+$' 
		" parameter is a word
		let	nr	= index( s:PCseverityName, tolower(sev) )
		if nr > 0
			let s:Perl_PerlcriticSeverity = nr
		endif
	else
		"
		echomsg "wrong argument '".a:severity."' / severity is set to ".s:Perl_PerlcriticSeverity
		return
	endif
	echomsg "perlcritic severity is set to ".s:Perl_PerlcriticSeverity
endfunction    " ----------  end of function Perl_GetPerlcriticSeverity  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  Perl_PerlcriticSeverityInput
"   DESCRIPTION:  read perlcritic severity from the command line
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! Perl_PerlcriticSeverityInput ()
		let retval = input( "perlcritic severity  (current = '".s:PCseverityName[s:Perl_PerlcriticSeverity]."' / tab exp.): ", '', 'customlist,Perl_PerlcriticSeverityList' )
		redraw!
		call Perl_GetPerlcriticSeverity( retval )
	return
endfunction    " ----------  end of function Perl_PerlcriticSeverityInput  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  Perl_GetPerlcriticVerbosity
"   DESCRIPTION:  perlcritic verbosity : used in command definition
"    PARAMETERS:  verbosity - perlcritic verbosity
"       RETURNS:  
"===============================================================================
function! Perl_GetPerlcriticVerbosity ( verbosity )
	let s:Perl_PerlcriticVerbosity = 4
	let	vrb	= a:verbosity
  let vrb	= substitute( vrb, '^\s\+', '', '' )  	     			" remove leading whitespaces
  let vrb	= substitute( vrb, '\s\+$', '', '' )	       			" remove trailing whitespaces
  if vrb =~ '^\d\{1,2}$' && 1 <= vrb && vrb <= 11
    let s:Perl_PerlcriticVerbosity = vrb
		echomsg "perlcritic verbosity is set to ".s:Perl_PerlcriticVerbosity
	else
		echomsg "wrong argument '".a:verbosity."' / perlcritic verbosity is set to ".s:Perl_PerlcriticVerbosity
  endif
endfunction    " ----------  end of function Perl_GetPerlcriticVerbosity  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  Perl_PerlcriticVerbosityInput
"   DESCRIPTION:  read perlcritic verbosity from the command line
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! Perl_PerlcriticVerbosityInput ()
		let retval = input( "perlcritic verbosity  (current = ".s:Perl_PerlcriticVerbosity." / tab exp.): ", '', 'customlist,Perl_PerlcriticVerbosityList' )
		redraw!
		call Perl_GetPerlcriticVerbosity( retval )
	return
endfunction    " ----------  end of function Perl_PerlcriticVerbosityInput  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  Perl_GetPerlcriticOptions
"   DESCRIPTION:  perlcritic options : used in command definition
"    PARAMETERS:  ... - 
"       RETURNS:  
"===============================================================================
function! Perl_GetPerlcriticOptions ( ... )
	let s:Perl_PerlcriticOptions = ""
	if a:0 > 0
		let s:Perl_PerlcriticOptions = a:1
	endif
endfunction    " ----------  end of function Perl_GetPerlcriticOptions  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  Perl_PerlcriticOptionsInput
"   DESCRIPTION:  read perlcritic options from the command line
"    PARAMETERS:  -
"       RETURNS:  
"===============================================================================
function! Perl_PerlcriticOptionsInput ()
		let retval = input( "perlcritic options (current = '".s:Perl_PerlcriticOptions."'): " )
		redraw!
		call Perl_GetPerlcriticOptions( retval )
	return
endfunction    " ----------  end of function Perl_PerlcriticOptionsInput  ----------
"------------------------------------------------------------------------------
"  Perl_SaveGlobalOption
"  param 1 : option name
"  param 2 : characters to be escaped (optional)
"------------------------------------------------------------------------------
function! s:Perl_SaveGlobalOption ( option, ... )
	exe 'let escaped =&'.a:option
	if a:0 == 0
		let escaped	= escape( escaped, ' |"\' )
	else
		let escaped	= escape( escaped, ' |"\'.a:1 )
	endif
	let s:Perl_saved_global_option[a:option]	= escaped
endfunction    " ----------  end of function Perl_SaveGlobalOption  ----------
"
"------------------------------------------------------------------------------
"  Perl_RestoreGlobalOption
"------------------------------------------------------------------------------
function! s:Perl_RestoreGlobalOption ( option )
	exe ':set '.a:option.'='.s:Perl_saved_global_option[a:option]
endfunction    " ----------  end of function Perl_RestoreGlobalOption  ----------
"
"===  FUNCTION  ================================================================
"          NAME:  Perl_Input
"   DESCRIPTION:  Input after a highlighted prompt
"    PARAMETERS:  prompt - prompt
"                 text   - default reply
"                 ...    - completion (optional)
"       RETURNS:  
"===============================================================================
function! Perl_Input ( prompt, text, ... )
	echohl Search																					" highlight prompt
	call inputsave()																			" preserve typeahead
	if a:0 == 0 || empty(a:1)
		let retval	=input( a:prompt, a:text )
	else
		let retval	=input( a:prompt, a:text, a:1 )
	endif
	call inputrestore()																		" restore typeahead
	echohl None																						" reset highlighting
	let retval  = substitute( retval, '^\s\+', "", "" )		" remove leading whitespaces
	let retval  = substitute( retval, '\s\+$', "", "" )		" remove trailing whitespaces
	return retval
endfunction    " ----------  end of function Perl_Input ----------
