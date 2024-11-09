" EditSimilar/Root.vim: Custom completion for EditSimilar root (file extension) commands.
"
" DEPENDENCIES:
"   - EditSimilar.vim autoload script
"   - ingo/collections.vim autoload script
"   - ingo/compat.vim autoload script
"   - ingo/fs/path.vim autoload script
"   - ingo/str.vim autoload script
"
" Copyright: (C) 2012-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

" Root (i.e. file extension) commands.
function! EditSimilar#Root#Open( opencmd, OptionParser, isCreateNew, filespec, extensionArguments )
    let [l:newExtensions, l:cmdOptions] = [ingo#cmdargs#file#SplitAndUnescape(a:extensionArguments), '']
    if ! empty(a:OptionParser)
	let [l:newExtensions, l:cmdOptions] = call(a:OptionParser, [l:newExtensions])
    endif

    let [l:fullmatch, l:dots, l:newExtension; l:rest] = matchlist(get(l:newExtensions, 0, ''), '\(^\.*\)\(.*$\)')

    " Each leading '.' removes one file extension from the original filename; a
    " single dot is optional.
    let l:rootRemovalNum = (strlen(l:dots) > 1 ? strlen(l:dots) : 1)

    let l:newFilespec = fnamemodify(a:filespec, repeat(':r', l:rootRemovalNum)) . (! empty(l:newExtension) ? '.' . l:newExtension : '')
    return EditSimilar#Open(a:opencmd, l:cmdOptions, a:isCreateNew, 1, a:filespec, l:newFilespec, fnamemodify(l:newFilespec, ':t'))
endfunction

function! s:Complete( dots, argLead, filenameGlob )
    let l:roots = ingo#collections#UniqueSorted(sort(
    \   filter(
    \       ingo#collections#Flatten1(map(
    \           ingo#compat#glob(a:filenameGlob . '.' . a:argLead . '*', 0, 1),
    \           '[' .
    \               'fnamemodify(v:val, ":e"),' .
    \               'fnamemodify(v:val, ":e:e"),' .
    \               'fnamemodify(v:val, ":e:e:e")' .
    \           ']'
    \       )),
    \       'ingo#str#StartsWith(v:val, a:argLead)' .
    \           ' && v:val !=# ' . string(expand('%:e')) .
    \           ' && v:val !=# ' . string(expand('%:e:e')) .
    \           ' && v:val !=# ' . string(expand('%:e:e:e'))
    \   )
    \))
    " Note: No need for fnameescape(); the Root commands don't support Vim
    " special characters like % and # and therefore do the escaping themselves.

    return map(
    \   l:roots,
    \   'a:dots . v:val'
    \)
endfunction

function! EditSimilar#Root#Complete( ArgLead, CmdLine, CursorPos )
    let [l:dots, l:argLead] = matchlist(a:ArgLead, '^\(\.*\)\(.*\)$')[1:2]
    let l:baseFilename = expand('%' . repeat(':r', max([1, len(l:dots)])))
    return s:Complete(l:dots, l:argLead, l:baseFilename)
endfunction

function! EditSimilar#Root#CompleteAny( ArgLead, CmdLine, CursorPos )
    let [l:dots, l:argLead] = matchlist(a:ArgLead, '^\(\.*\)\(.*\)$')[1:2]
    return s:Complete(l:dots, l:argLead, ingo#fs#path#Combine(expand('%:h'), '*'))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
