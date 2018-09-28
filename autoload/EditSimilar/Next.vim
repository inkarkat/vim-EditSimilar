" EditSimilar/Next.vim: Custom completion for EditSimilar directory contents commands.
"
" DEPENDENCIES:
"   - EditSimilar.vim autoload script
"   - ingo/compat.vim autoload script
"   - ingo/fs/path.vim autoload script
"   - ingo/err.vim autoload script
"
" Copyright: (C) 2012-2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

" Next / Previous commands.
function! EditSimilar#Next#GetDirectoryEntries( dirSpec, fileGlobs )
    let l:dirSpec = ingo#escape#file#wildcardescape(a:dirSpec)
    let l:files = []

    " Get list of files, apply 'wildignore'.
    for l:fileGlob in a:fileGlobs
	let l:files += ingo#compat#glob(ingo#fs#path#Combine(l:dirSpec, l:fileGlob), 0, 1)
	" Note: No need to normalize here; glob() always returns results with
	" the default path separator.
    endfor

    " Remove . and .. pseudo-directories.
    call filter(l:files, 'v:val !~# "[\\\\/]\\.\\.\\?$"')

    return l:files
endfunction
let s:defaultFileGlobs = ['*']
function! s:ErrorMsg( text, fileGlobs, ... )
    call ingo#err#Set(a:text . (a:fileGlobs ==# s:defaultFileGlobs ? '' : ' matching ' . join(a:fileGlobs, ' or ')) . (a:0 ? ': ' . a:1 : ''))
endfunction
function! EditSimilar#Next#Open( opencmd, OptionParser, isCreateNew, filespec, difference, direction, fileGlobsString )
    " To be able to find the current filespec in the glob results with a simple
    " string compare, canonicalize all path separators to what Vim is internally
    " using, i.e. depending on the 'shellslash' option.
    let l:dirSpec = ingo#fs#path#Normalize(fnamemodify(a:filespec, ':h'))
    let l:dirSpec = (l:dirSpec ==# '.' ? '' : l:dirSpec)

    let [l:fileGlobs, l:cmdOptions] = [ingo#cmdargs#file#SplitAndUnescape(a:fileGlobsString), '']
    if ! empty(a:OptionParser)
	let [l:fileGlobs, l:cmdOptions] = call(a:OptionParser, [l:fileGlobs])
    endif
    if empty(l:fileGlobs)
	let l:fileGlobs = s:defaultFileGlobs
    endif
    let l:files = filter(EditSimilar#Next#GetDirectoryEntries(l:dirSpec, l:fileGlobs), '! isdirectory(v:val)')

    let l:currentIndex = index(l:files, ingo#fs#path#Normalize(a:filespec))
    if l:currentIndex == -1
	if len(l:files) == 0
	    call s:ErrorMsg('No files in this directory', l:fileGlobs)
	else
	    call s:ErrorMsg('Cannot locate current file', l:fileGlobs, a:filespec)
	endif
	return 0
    elseif l:currentIndex == 0 && len(l:files) == 1
	call s:ErrorMsg('This is the sole file in the directory', l:fileGlobs)
	return 0
    elseif l:currentIndex == 0 && a:direction == -1
	call s:ErrorMsg('No previous file', l:fileGlobs)
	return 0
    elseif l:currentIndex == (len(l:files) - 1) && a:direction == 1
	call s:ErrorMsg('No next file', l:fileGlobs)
	return 0
    endif

    " A passed difference of 0 means that no [count] was specified and thus
    " skipping over missing numbers is enabled.
    let l:difference = max([a:difference, 1])

    let l:offset = a:direction * l:difference
    let l:replacementIndex = l:currentIndex + l:offset
    let l:replacementIndex =
    \   max([
    \       min([l:replacementIndex, len(l:files) - 1]),
    \       0
    \   ])
    let l:replacementFilespec = l:files[l:replacementIndex]

    " Note: The a:isCreateNew flag has no meaning here, as all replacement
    " files do already exist.
    return EditSimilar#Open(a:opencmd, l:cmdOptions, 0, 0, a:filespec, l:replacementFilespec, '')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
