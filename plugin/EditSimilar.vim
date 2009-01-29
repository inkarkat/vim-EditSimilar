" TODO: summary
"
" DESCRIPTION:
" USAGE:
" INSTALLATION:
"   Put the script into your user or system VIM plugin directory (e.g.
"   ~/.vim/plugin). 

" DEPENDENCIES:
"   - Requires VIM 7.0 or higher. 

" CONFIGURATION:
" INTEGRATION:
" LIMITATIONS:
" ASSUMPTIONS:
" KNOWN PROBLEMS:
" TODO:
"
" Copyright: (C) 2009 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	001	29-Jan-2009	file creation

" Avoid installing twice or when in unsupported VIM version. 
if exists('g:loaded_EditSimilar') || (v:version < 700)
    finish
endif
let g:loaded_EditSimilar = 1

let s:patternPattern = '\(^.\+\)=\(.*$\)'
function! s:OpenSubstitute( opencmd, ... )
    let l:original = expand('%:p')
    let l:replacement = l:original

    for l:pattern in a:000
	if l:pattern !~# s:patternPattern
	    echohl ErrorMsg
	    let v:errmsg = 'Not a substitution: ' . l:pattern
	    echomsg v:errmsg
	    echohl NONE
	    return
	endif
	let [l:match, l:from, l:to; l:rest] = matchlist( l:pattern, s:patternPattern )
	if empty(l:match) || empty(l:from) | throw 'ASSERT: Pattern can be applied. ' | endif
	let l:replacement = substitute( l:replacement, '\V' . escape(l:from, '\'), escape(l:to, '\&~'), 'g' )
    endfor

    if l:replacement ==# l:original
	echohl ErrorMsg
	let v:errmsg = 'Nothing substituted'
	echomsg v:errmsg
	echohl NONE
	return
    endif

"****D echomsg '****' . a:opencmd . ' ' . l:replacement | return
    execute a:opencmd escapings#fnameescape(l:replacement)
endfunction
command! -bar -nargs=+ Esubstitute	call <SID>OpenSubstitute('edit', <f-args>)
command! -bar -nargs=+ Spsubstitute	call <SID>OpenSubstitute('split', <f-args>)
command! -bar -nargs=+ Vspsubstitute	call <SID>OpenSubstitute('vsplit', <f-args>)

function! s:OpenOffset( opencmd, offset )
    let l:original = expand('%:p')
    let l:replacement = l:original
endfunction
command! -bar -count=1 Enext	    call <SID>OpenOffset('edit', <count>)
command! -bar -count=1 Eprevious    call <SID>OpenOffset('edit', -<count>)

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
