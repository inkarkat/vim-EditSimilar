" EditSimilar.vim: Commands to edit files that have a filename similar to the
" current file's. 
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
"	002	31-Jan-2009	Moved :Sproot and :Sppattern commands from
"				ingocommands.vim. 
"				ENH: :Sppattern now notifies when no new windows
"				have been opened. 
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

function! s:Open( opencmd, isCreateNew, originalFilespec, replacementFilespec, createNewNotAllowedMsg )
    if a:replacementFilespec ==# a:originalFilespec
	call s:ErrorMsg('Nothing substituted')
	return
    endif
    if ! a:isCreateNew && ! filereadable(a:replacementFilespec) && ! isdirectory(a:replacementFilespec)
	call s:ErrorMsg('Substituted file does not exist (add ! to create)' . (empty(a:createNewNotAllowedMsg) ? '' : ': ' . a:createNewNotAllowedMsg))
	return
    endif

"****D echomsg '****' . a:opencmd . ' ' . a:replacementFilespec | return
    try
	execute a:opencmd escapings#fnameescape(a:replacementFilespec)
    catch /^Vim\%((\a\+)\)\=:E37/	" catch error E37: No write since last change (add ! to override)
	" The "add ! to override" is wrong here, we use the ! for another
	" purpose. 
	call s:ErrorMsg('No write since last change')
    catch /^Vim\%((\a\+)\)\=:E/
	" v:exception contains what is normally in v:errmsg, but with extra
	" exception source info prepended, which we cut away. 
	call s:ErrorMsg(substitute(v:exception, '^Vim\%((\a\+)\)\=:', '', ''))
    endtry
endfunction

let s:patternPattern = '\(^.\+\)=\(.*$\)'
function! s:Substitute( text, patterns )
    let l:replacement = a:text
    let l:failedPatterns = []

    for l:pattern in a:patterns
	if l:pattern !~# s:patternPattern
	    throw 'EditSimilar: Not a substitution: ' . l:pattern
	endif
	let [l:match, l:from, l:to; l:rest] = matchlist( l:pattern, s:patternPattern )
	if empty(l:match) || empty(l:from) | throw 'ASSERT: Pattern can be applied. ' | endif
	let l:beforeReplacement = l:replacement
	let l:replacement = substitute( l:replacement, '\V' . escape(l:from, '\'), escape(l:to, '\&~'), 'g' )
	if l:replacement ==# l:beforeReplacement
	    call add(l:failedPatterns, l:pattern)
	endif
    endfor

    return [l:replacement, l:failedPatterns]
endfunction
function! s:OpenSubstitute( opencmd, isCreateNew, filespec, ... )
    let l:pathSeparator = (exists('+shellslash') && ! &shellslash ? '\' : '/')
    let l:originalPathspec = fnamemodify(a:filespec, ':p:h') . l:pathSeparator
    let l:originalFilename = fnamemodify(a:filespec, ':t')
    let l:originalFilespec = l:originalPathspec . l:originalFilename
    try
	let [l:replacementFilename, l:failedPatterns] = s:Substitute(l:originalFilename, a:000)
	let l:replacementFilespec = l:originalPathspec . l:replacementFilename
	let l:replacementMsg = l:replacementFilename
	if ! empty(l:failedPatterns)
	    let [l:replacementPathspec, l:failedPatterns] = s:Substitute(l:originalPathspec, l:failedPatterns)
	    let l:replacementFilespec = l:replacementPathspec . l:replacementFilename
	    let l:replacementMsg = fnamemodify(l:replacementFilespec, ':~:.')
	endif
	call s:Open(a:opencmd, a:isCreateNew, l:originalFilespec, l:replacementFilespec, l:replacementMsg)
    catch /^EditSimilar:/
	call s:ErrorMsg(substitute(v:exception, '^EditSimilar:\s*', '', ''))
    endtry
endfunction

let s:digitPattern = '\d\+\ze\D*$'
function! s:Offset( text, offset, minimum )
    let l:currentNumber = matchstr(a:text, s:digitPattern)
    let l:nextNumber = max([str2nr(l:currentNumber, 10) + a:offset, a:minimum])
    let l:nextNumberString = printf('%0' . strlen(l:currentNumber) . 'd', l:nextNumber)
    return [l:nextNumberString, substitute(a:text, s:digitPattern, l:nextNumberString, '')]
endfunction
function! s:OpenOffset( opencmd, isCreateNew, filespec, difference, direction )
    let l:originalNumber = matchstr(a:filespec, s:digitPattern)
    if empty(l:originalNumber)
	call s:ErrorMsg('No number in filespec')
	return
    endif

    if a:isCreateNew
	let [l:replacementNumberString, l:replacement] = s:Offset(a:filespec, a:direction * a:difference, 0)
	if str2nr(l:replacementNumberString, 10) == 0 && a:direction == -1 && a:difference > 1 && ! filereadable(l:replacement)
	    let [l:replacementNumberString, l:replacement] = s:Offset(a:filespec, a:direction * a:difference, 1)
	endif
	let l:replacementMsg = '#' . l:replacementNumberString
    else
	let l:difference = a:difference
	let l:replacementMsg = ''
	while l:difference > 0
	    let [l:replacementNumberString, l:replacement] = s:Offset(a:filespec, a:direction * l:difference, 0)
	    if empty(l:replacementMsg) | let l:replacementMsg = '#' . l:replacementNumberString | endif
	    if filereadable(l:replacement)
		break
	    endif
	    let l:difference -= 1
	endwhile
    endif

    call s:Open(a:opencmd, a:isCreateNew, a:filespec, l:replacement, l:replacementMsg . ' (from #' . l:originalNumber . ')')
endfunction

":Esubstitute[!] <text>=<replacement> [<text>=<replacement> [...]]
":Spsubstitute[!] <text>=<replacement> [<text>=<replacement> [...]]
":Vspsubstitute[!] <text>=<replacement> [<text>=<replacement> [...]]
"			Replaces all literal occurrences of <text> in the
"			currently edited file with <replacement>, and opens the
"			resulting file. If all substitutions can be made on the
"			filename, the pathspec is left alone (so you don't get
"			any false replacements on a long pathspec). Otherwise,
"			the substitutions that weren't applicable to the
"			filename are done to the full absolute pathspec. 
"
"			This way, you can substitute an the entire path by
"			specifying the same substitution twice: 
"			    /etc/test/superapp/test001.cfg
"			    :Esubstitute test=prod
"			    /etc/test/superapp/prod001.cfg
"			    :Esubstitute test=prod test=prod
"			    /etc/prod/superapp/prod001.cfg
"			Or perform different substitutions on filename and
"			pathspec: 
"			    /etc/test/superapp/test001.cfg
"			    :Esubstitute test=prod test=production
"			    /etc/production/superapp/prod001.cfg
"
"			Add [!] to create a new file when the substituted file
"			does not exist. 
"
command! -bar -bang -nargs=+ Esubstitute	call <SID>OpenSubstitute('edit',   <bang>0, expand('%:p'), <f-args>)
command! -bar -bang -nargs=+ Spsubstitute	call <SID>OpenSubstitute('split',  <bang>0, expand('%:p'), <f-args>)
command! -bar -bang -nargs=+ Vspsubstitute	call <SID>OpenSubstitute('vsplit', <bang>0, expand('%:p'), <f-args>)

":FileSubstitute <text>=<replacement> [<text>=<replacement> [...]] 
":WriteSubstitute[!] <text>=<replacement> [<text>=<replacement> [...]] 
":SaveSubstitute[!] <text>=<replacement> [<text>=<replacement> [...]] 
"			Replaces all literal occurrences of <text> in the
"			currently edited file with <replacement>, and sets /
"			writes the resulting file. 
"			The [!] is needed to overwrite an existing file.
command! -bar	    -nargs=+ FileSubstitute	call <SID>OpenSubstitute('file', 1, expand('%:p'), <f-args>)
command! -bar -bang -nargs=+ WriteSubstitute	call <SID>OpenSubstitute('write<bang>', 1, expand('%:p'), <f-args>)
command! -bar -bang -nargs=+ SaveSubstitute	call <SID>OpenSubstitute('saveas<bang>', 1, expand('%:p'), <f-args>)



":[N]Enext[!] [N]
":[N]Eprevious[!] [N]
":[N]Spnext[!] [N]
":[N]Spprevious[!] [N]
":[N]Vspnext[!] [N]
":[N]Vspprevious[!] [N]
"			Increases the last number found inside the full absolute
"			filespec of the currently edited file by [N]. (A fixed
"			number width via padding with leading zeros is maintained.) 
"			If a file with that number does not exist, the
"			substitution is retried with smaller offsets, unless [!]
"			is specified. With [!], a new file is created when the
"			substituted file does not exist. 
"			When jumping to previous numbers, the resulting number
"			will never be negative. A jump with [!] and [N] > 1 will
"			create a file with number 1, not 0, but you can still
"			create number 0 by repeating the command with [N] = 1. 
"			Examples: 
"			test007.txt in a directory also containing 003-013. 
"			:Enext	    -> test008.txt
"			:99Enext    -> test013.txt
"			:99Enext!   -> test106.txt [New File]
"			:99Eprev    -> test003.txt
"			:99Eprev!   -> test001.txt [New File]
command! -bar -bang -count=1 Enext		call <SID>OpenOffset('edit',   <bang>0, expand('%:p'), <count>,  1)
command! -bar -bang -count=1 Eprevious		call <SID>OpenOffset('edit',   <bang>0, expand('%:p'), <count>, -1)
command! -bar -bang -count=1 Spnext		call <SID>OpenOffset('split',  <bang>0, expand('%:p'), <count>,  1)
command! -bar -bang -count=1 Spprevious		call <SID>OpenOffset('split',  <bang>0, expand('%:p'), <count>, -1)
command! -bar -bang -count=1 Vspnext		call <SID>OpenOffset('vsplit', <bang>0, expand('%:p'), <count>,  1)
command! -bar -bang -count=1 Vspprevious	call <SID>OpenOffset('vsplit', <bang>0, expand('%:p'), <count>, -1)

":[N]FileNext [N]
":[N]FilePrevious [N]
":[N]WriteNext[!] [N]
":[N]WritePrevious[!] [N]
":[N]SaveNext[!] [N]
":[N]SavePrevious[!] [N]
"			Increases the last number found inside the full absolute
"			filespec of the currently edited file by [N] and sets /
"			writes that file. (A fixed number width via padding with
"			leading zeros is maintained.) 
"			The [!] is needed to overwrite an existing file.
command! -bar	    -count=1 FileNext		call <SID>OpenOffset('file', 1, expand('%:p'), <count>,  1)
command! -bar	    -count=1 FilePrevious	call <SID>OpenOffset('file', 1, expand('%:p'), <count>, -1)
command! -bar -bang -count=1 WriteNext		call <SID>OpenOffset('write<bang>', 1, expand('%:p'), <count>,  1)
command! -bar -bang -count=1 WritePrevious	call <SID>OpenOffset('write<bang>', 1, expand('%:p'), <count>, -1)
command! -bar -bang -count=1 SaveNext		call <SID>OpenOffset('saveas<bang>', 1, expand('%:p'), <count>,  1)
command! -bar -bang -count=1 SavePrevious	call <SID>OpenOffset('saveas<bang>', 1, expand('%:p'), <count>, -1)


":Eroot <extension>
":Sproot <extension>
":Vsproot <extension>
"			Switches the current file's extension: 
"			Edits a file with the current file's path and name, but
"			replaces the file extension with the passed one. 
command! -bar -nargs=1 Eroot     edit %:p:r.<args>
command! -bar -nargs=1 Sproot   split %:p:r.<args>
command! -bar -nargs=1 Vsproot vsplit %:p:r.<args>

":FileRoot <extension>
":WriteRoot[!] <extension>
":SaveRoot[!] <extension>
"			Sets / saves a file with the current file's path and
"			name, but replaces the file extension with the passed
"			one. 
command! -bar 	    -nargs=1 FileRoot	file %:p:r.<args>
command! -bar -bang -nargs=1 WriteRoot	write<bang> %:p:r.<args>
command! -bar -bang -nargs=1 SaveRoot	saveas<bang> %:p:r.<args>



":Sppattern <file_pattern>
":Vsppattern <file_pattern>
"			Open all files matching <file_pattern> in split windows.
"			If one of the files is already open, no second split is
"			generated. 
function! s:SplitPattern( splitcmd, pattern )
    let l:openCnt = 0
    " Expand all files to their absolute path, because the CWD may change when a
    " file is opened (e.g. due to autocmds or :set autochdir). 

    let l:filespecs = map( split(glob(a:pattern), "\n"), "fnamemodify(v:val, ':p')" )
    for l:filespec in l:filespecs
	if bufwinnr(l:filespec) == -1
	    " Convert filespec returned by glob() into filespec suitable for ex
	    " command: Escape space, % and #. 
	    execute a:splitcmd . ' ' . substitute( l:filespec, '[ %#]', '\\\0', 'g' )
	    let l:openCnt += 1
	endif
    endfor

    " Make all windows the same size if more than one has been opened. 
    if l:openCnt > 1
	wincmd =
    elseif len(l:filespecs) == 0
	call s:ErrorMsg('No matches')
    elseif l:openCnt == 0
	echomsg 'No new matches that haven''t yet been opened'
    endif
endfunction

" Note: We cannot use -complete=file; it results in E77: too many files error
" when using a pattern. 
command! -bar -nargs=1 Sppattern    call <SID>SplitPattern('split', <f-args>)
command! -bar -nargs=1 Vsppattern   call <SID>SplitPattern('vsplit', <f-args>)


" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
