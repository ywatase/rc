au BufNewFile,BufRead *.tt2 call s:AdjustTT2Type()

func! s:AdjustTT2Type()
    if ( getline(1) . getline(2) . getline(3) =~ '<\chtml' && getline(1) . getline(2) . getline(3) !~ '<[%?]' ) || ( getline(1) =~ '<!DOCTYPE HTML' )
        setf tt2html
    else
        setf tt2
    endif
endfunc

"To define START_TAG and END_TAG you like, you can set any pair of tags to 'b:tt2_syn_tags':
"    ASP
"    :let b:tt2_syn_tags = '<% %>'
"    PHP
"    :let b:tt2_syn_tags = '<? ?>'
"    TT2 and HTML
"    :let b:tt2_syn_tags = '\[% %] <!-- -->' 
