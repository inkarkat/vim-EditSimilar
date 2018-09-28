" EditSimilar/Pattern.vim: Custom completion for EditSimilar pattern commands.
"
" DEPENDENCIES:
"   - ingo/cmdargs/file.vim autoload script
"   - ingo/cmdargs/glob.vim autoload script
"   - ingo/compat.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/escape/file.vim autoload script
"
" Copyright: (C) 2012-2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! EditSimilar#Pattern#Split( splitcmd, OptionParser, filePatternsString, isSkipVisible )
    let [l:filePatterns, l:cmdOptions] = [ingo#cmdargs#file#SplitAndUnescape(a:filePatternsString), '']

    if ! empty(a:OptionParser)
	let [l:filePatterns, l:cmdOptions] = call(a:OptionParser, [l:filePatterns])
    endif
    let l:filespecs = ingo#cmdargs#glob#Expand(l:filePatterns)

    " Expand all files to their absolute path, because the CWD may change when a
    " file is opened (e.g. due to autocmds or :set autochdir).
    let l:filespecs = map(ingo#cmdargs#glob#Expand(l:filePatterns), "fnamemodify(v:val, ':p')")

    let l:openCnt = 0
    for l:filespec in map(l:filespecs, 'fnamemodify(v:val, ":p")')
	if ! a:isSkipVisible || bufwinnr(ingo#escape#file#bufnameescape(l:filespec)) == -1
	    " The glob (usually) returns file names sorted alphabetially, and
	    " the splits should also be arranged like that (like vim -o file1
	    " file2 file3 does). So, we only observe 'splitbelow' and
	    " 'splitright' for the very first split, and then force splitting
	    " :belowright.
	    let l:splitWhere = (l:openCnt == 0 ? '' : 'belowright')

	    try
		execute l:splitWhere a:splitcmd l:cmdOptions ingo#compat#fnameescape(fnamemodify(l:filespec, ':~:.'))
	    catch /^Vim\%((\a\+)\)\=:/
		call ingo#err#SetVimException()
		return 0
	    endtry
	    let l:openCnt += 1
	endif
    endfor

    " Make all windows the same size if more than one has been opened.
    if l:openCnt > 1
	wincmd =
    elseif len(l:filespecs) == 0
	call ingo#err#Set('No matches')
	return 0
    elseif l:openCnt == 0
	echomsg 'No new matches that haven''t yet been opened'
    endif
    return 1
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
