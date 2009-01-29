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

function! s:ErrorMsg( text )
    echohl ErrorMsg
    let v:errmsg = a:text
    echomsg v:errmsg
    echohl None
endfunction 

function! s:Open( opencmd, filespecs )
    if empty(a:filespecs)
	return
    endif

    let [l:originalFilespec, l:replacementFilespec] = a:filespecs
    if l:replacementFilespec ==# l:originalFilespec
	call s:ErrorMsg('Nothing substituted')
	return
    endif

"****D echomsg '****' . a:opencmd . ' ' . l:replacementFilespec | return
    execute a:opencmd escapings#fnameescape(l:replacementFilespec)
endfunction

let s:patternPattern = '\(^.\+\)=\(.*$\)'
function! s:Substitute( filespec, ... )
    let l:replacement = a:filespec

    for l:pattern in a:000
	if l:pattern !~# s:patternPattern
	    call s:ErrorMsg('Not a substitution: ' . l:pattern)
	    return []
	endif
	let [l:match, l:from, l:to; l:rest] = matchlist( l:pattern, s:patternPattern )
	if empty(l:match) || empty(l:from) | throw 'ASSERT: Pattern can be applied. ' | endif
	let l:replacement = substitute( l:replacement, '\V' . escape(l:from, '\'), escape(l:to, '\&~'), 'g' )
    endfor

    return [a:filespec, l:replacement]
endfunction

let s:digitPattern = '\d\+\ze\D*$'
function! s:Offset( filespec, offset )
    let l:number = matchstr(a:filespec, s:digitPattern)
    if empty(l:number)
	call s:ErrorMsg('No number in filespec')
	return []
    endif
    let l:nextNumber = max([l:number + a:offset, (a:offset < -1 ? 1 : 0)])
    let l:nextNumberString = printf('%0' . strlen(l:number) . 'd', l:nextNumber)

    return [a:filespec, substitute(a:filespec, s:digitPattern, l:nextNumberString, '')]
endfunction

command! -bar -nargs=+ Esubstitute	call <SID>Open('edit', <SID>Substitute(expand('%:p'), <f-args>))
command! -bar -nargs=+ Spsubstitute	call <SID>Open('split', <SID>Substitute(expand('%:p'), <f-args>))
command! -bar -nargs=+ Vspsubstitute	call <SID>Open('vsplit', <SID>Substitute(expand('%:p'), <f-args>))

command! -bar -count=1 Enext		call <SID>Open('edit', <SID>Offset(expand('%:p'), <count>))
command! -bar -count=1 Eprevious	call <SID>Open('edit', <SID>Offset(expand('%:p'), -<count>))
command! -bar -count=1 Spnext		call <SID>Open('split', <SID>Offset(expand('%:p'), <count>))
command! -bar -count=1 Spprevious	call <SID>Open('split', <SID>Offset(expand('%:p'), -<count>))
command! -bar -count=1 Vspnext		call <SID>Open('vsplit', <SID>Offset(expand('%:p'), <count>))
command! -bar -count=1 Vspprevious	call <SID>Open('vsplit', <SID>Offset(expand('%:p'), -<count>))

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
