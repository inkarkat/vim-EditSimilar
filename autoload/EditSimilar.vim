" EditSimilar.vim: Commands to edit files with a similar filename.
"
" DEPENDENCIES:
"   - ingo/compat.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/fs/path.vim autoload script
"   - ingo/escape/file.vim autoload script
"
" Copyright: (C) 2009-2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! EditSimilar#Open( opencmd, isCreateNew, isFilePattern, originalFilespec, replacementFilespec, createNewNotAllowedMsg )
"*******************************************************************************
"* PURPOSE:
"   Open a substituted filespec via the a:opencmd Ex command.
"* ASSUMPTIONS / PRECONDITIONS:
"   None.
"* EFFECTS / POSTCONDITIONS:
"   None.
"* INPUTS:
"   a:opencmd	Ex command to open the file (e.g. 'edit', 'split', etc.)
"   a:isCreateNew   Flag whether a non-existing filespec will be opened, thereby
"		    creating a new file.
"   a:isFilePattern Flag whether file wildcards will be resolved (if the
"		    filespec itself doesn't exist. If the resolution of
"		    wildcards yields a single (existing) file, it is opened.
"		    Multiple candidates will result in an error message.
"   a:originalFilespec	Original, unmodified filespec; is used for check that
"			something actually was substituted.
"   a:replacementFilespec   Filespec to be opened. May contain wildcards.
"   a:createNewNotAllowedMsg	(Optional) user message to be appended to the
"				"Substituted file does not exist" error message;
"				typically contains the (user-readable)
"				representation of a:replacementFilespec.
"* RETURN VALUES:
"   None.
"*******************************************************************************
    let l:filespecToOpen = a:replacementFilespec

    if l:filespecToOpen ==# a:originalFilespec
	call ingo#err#Set('Nothing substituted')
	return 0
    endif

    if a:isFilePattern && ! ingo#fs#path#Exists(l:filespecToOpen)
	let l:files = ingo#compat#glob(l:filespecToOpen, 0, 1)
	if len(l:files) > 1
	    call ingo#err#Set('Too many file names')
	    return 0
	elseif len(l:files) == 1
	    let l:filespecToOpen = l:files[0]
	    if l:filespecToOpen ==# a:originalFilespec
		call ingo#err#Set('Nothing substituted')
		return 0
	    endif
	endif
    endif
    if ! ingo#fs#path#Exists(l:filespecToOpen)
	if bufexists(l:filespecToOpen)  " Note: bufexists() does not need ingo#escape#file#bufnameescape() escaping; it only matches relative or full paths, anyway.
	    " The file only exists in an unpersisted Vim buffer so far.
	else
	    if ! a:isCreateNew
		call ingo#err#Set('Substituted file does not exist (add ! to create)' . (empty(a:createNewNotAllowedMsg) ? '' : ': ' . a:createNewNotAllowedMsg))
		return 0
	    endif
	endif
    endif

"****D echomsg '****' . a:opencmd . ' ' . l:filespecToOpen | return
    if exists('+autochdir') && &autochdir && a:opencmd =~# '^pedit\>'
	" XXX: :pedit uses the CWD of existing preview window instead of the CWD
	" of the current window; leading to wrong not-existing files being
	" opened. Work around this by always passing a full absolute filespec.
	let l:filespec = fnamemodify(l:filespecToOpen, ':p')
    else
	let l:filespec = fnamemodify(l:filespecToOpen, ':~:.')
    endif
    try
	execute a:opencmd ingo#compat#fnameescape(l:filespec)
	return 1
    catch /^Vim\%((\a\+)\)\=:E37:/	" E37: No write since last change (add ! to override)
	" The "(add ! to override)" is wrong here, we use the ! for another
	" purpose, so filter it away.
	call ingo#err#Set(substitute(substitute(v:exception, '^\CVim\%((\a\+)\)\=:E37:\s*', '', ''), '\s*(.*)', '', 'g'))
	return 0
    catch /^Vim\%((\a\+)\)\=:/
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction

function! EditSimilar#OptionParser( filePatterns )
    let [l:filePatterns, l:fileOptions] = ingo#cmdargs#file#FilterFileOptions(a:filePatterns)
    return [l:filePatterns, ingo#cmdargs#file#FileOptionsToEscapedExCommandLine(l:fileOptions)]
endfunction

function! EditSimilar#FileOptionsAndCommandsParser( filePatterns )
    let [l:filePatterns, l:fileOptionsAndCommands] = ingo#cmdargs#file#FilterFileOptionsAndCommands(a:filePatterns)
    return [l:filePatterns, ingo#cmdargs#file#FileOptionsAndCommandsToEscapedExCommandLine(l:fileOptionsAndCommands)]
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
