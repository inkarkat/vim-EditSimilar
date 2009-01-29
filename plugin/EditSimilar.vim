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

function! s:Open( opencmd, isCreateNew, originalFilespec, replacementFilespec )
    if a:replacementFilespec ==# a:originalFilespec
	call s:ErrorMsg('Nothing substituted')
	return
    endif
    if ! a:isCreateNew && ! filereadable(a:replacementFilespec) && ! isdirectory(a:replacementFilespec)
	call s:ErrorMsg('Substituted file does not exist (add ! to create)')
	return
    endif

"****D echomsg '****' . a:opencmd . ' ' . a:replacementFilespec | return
    execute a:opencmd escapings#fnameescape(a:replacementFilespec)
endfunction

let s:patternPattern = '\(^.\+\)=\(.*$\)'
function! s:OpenSubstitute( opencmd, isCreateNew, filespec, ... )
    let l:replacement = a:filespec

    for l:pattern in a:000
	if l:pattern !~# s:patternPattern
	    call s:ErrorMsg('Not a substitution: ' . l:pattern)
	    return
	endif
	let [l:match, l:from, l:to; l:rest] = matchlist( l:pattern, s:patternPattern )
	if empty(l:match) || empty(l:from) | throw 'ASSERT: Pattern can be applied. ' | endif
	let l:replacement = substitute( l:replacement, '\V' . escape(l:from, '\'), escape(l:to, '\&~'), 'g' )
    endfor

    call s:Open(a:opencmd, a:isCreateNew, a:filespec, l:replacement)
endfunction

let s:digitPattern = '\d\+\ze\D*$'
function! s:OpenOffset( opencmd, isCreateNew, filespec, offset )
    let l:number = matchstr(a:filespec, s:digitPattern)
    if empty(l:number)
	call s:ErrorMsg('No number in filespec')
	return
    endif
    let l:nextNumber = max([l:number + a:offset, (a:offset < -1 ? 1 : 0)])
    let l:nextNumberString = printf('%0' . strlen(l:number) . 'd', l:nextNumber)

    call s:Open(a:opencmd, a:isCreateNew, a:filespec, substitute(a:filespec, s:digitPattern, l:nextNumberString, ''))
endfunction

" :Esubstitute[!] <text>=<replacement> [<text>=<replacement> [...]]
"			Replaces all literal occurrences of <text> in the
"			currently edited file with <replacement>, and opens the
"			resulting file. If all substitutions can be made on the
"			filename, the pathspec is left alone (so you don't get
"			any false replacements on a long filespec). Otherwise,
"			the substitution is done on the full absolute filespec. 
"			Add [!] to create a new file when the substituted file
"			does not exist. 
"
command! -bar -bang -nargs=+ Esubstitute	call <SID>OpenSubstitute('edit',   <bang>0, expand('%:p'), <f-args>)
command! -bar -bang -nargs=+ Spsubstitute	call <SID>OpenSubstitute('split',  <bang>0, expand('%:p'), <f-args>)
command! -bar -bang -nargs=+ Vspsubstitute	call <SID>OpenSubstitute('vsplit', <bang>0, expand('%:p'), <f-args>)

" :[N]Enext[!] [N]
"			Increases the last number found inside the full absolute
"			filespec of the currently edited file by [N]. (A fixed
"			number width via padding with leading zeros is maintained.) 
"			If a file with that number does not exist, the
"			substitution is retried with smaller offsets, unless [!]
"			is specified. With [!], a new file is created when the
"			substituted file does not exist. 
"			When jumping to previous numbers, the resulting number
"			will never be negative. A jump with [N] > 1 will stop at
"			number 1 (with [!], or the lowest existing numbered file
"			without it), but you can still jump to number 0 if [N] =
"			1. 
command! -bar -bang -count=1 Enext		call <SID>OpenOffset('edit',   <bang>0, expand('%:p'), <count>)
command! -bar -bang -count=1 Eprevious		call <SID>OpenOffset('edit',   <bang>0, expand('%:p'), -<count>)
command! -bar -bang -count=1 Spnext		call <SID>OpenOffset('split',  <bang>0, expand('%:p'), <count>)
command! -bar -bang -count=1 Spprevious		call <SID>OpenOffset('split',  <bang>0, expand('%:p'), -<count>)
command! -bar -bang -count=1 Vspnext		call <SID>OpenOffset('vsplit', <bang>0, expand('%:p'), <count>)
command! -bar -bang -count=1 Vspprevious	call <SID>OpenOffset('vsplit', <bang>0, expand('%:p'), -<count>)

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
