" EditSimilar/Next.vim: Custom completion for EditSimilar directory contents commands.
"
" DEPENDENCIES:
"   - EditSimilar.vim autoload script
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   2.00.001	09-Jun-2012	file creation

" Next / Previous commands.
let s:pathSeparator = (exists('+shellslash') && ! &shellslash ? '\' : '/')
function! s:directoryEntries( dirSpec )
    " Get list of files, apply 'wildignore'.
    let l:files =
    \   split(glob(a:dirSpec . s:pathSeparator . '.*'), "\n") +
    \   split(glob(a:dirSpec . s:pathSeparator . '*'), "\n")
    " Remove . and .. pseudo-directories.
    call filter(l:files, 'v:val !~# "[\\\\/]\\.\\.\\?$"')
    return l:files
endfunction
function! EditSimilar#Next#Open( opencmd, isCreateNew, filespec, difference, direction )
    let l:dirSpec = fnamemodify(a:filespec, ':h')
    let l:dirSpec = (l:dirSpec ==# '.' ? '' : l:dirSpec)

    let l:files = filter(s:directoryEntries(l:dirSpec), '! isdirectory(v:val)')

    let l:currentIndex = index(l:files, a:filespec)
    if l:currentIndex == -1
	call EditSimilar#ErrorMsg('Cannot locate current file: ' . a:filespec)
	return
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

    call EditSimilar#Open(a:opencmd, a:isCreateNew, 0, a:filespec, l:replacementFilespec, '')
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
