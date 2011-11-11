" EditSimilar/CommandBuilder.vim: Utility for creating EditSimilar commands. 
"
" DEPENDENCIES:
"
" Copyright: (C) 2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	002	08-Nov-2011	Add documentation. 
"	001	05-Nov-2011	file creation
let s:save_cpo = &cpo
set cpo&vim

function! EditSimilar#CommandBuilder#SimilarFileOperations( commandPrefix, fileCommand, hasBang, createNew )
"******************************************************************************
"* PURPOSE:
"   Create *Next, *Previous and *Substitute commands with * = a:commandPrefix
"   for a:fileCommand. 
"* ASSUMPTIONS / PRECONDITIONS:
"   None. 
"* EFFECTS / POSTCONDITIONS:
"   Creates commands. 
"* INPUTS:
"   a:commandPrefix Name of the file operation command, used as a prefix to
"		    generate the entire command. 
"   a:fileCommand   Command to be invoked with the similar file name. 
"   a:isBang	    Flag whether a:fileCommand supports a bang. 
"   a:createNew	    Expression (e.g. '<bang>0') or flag whether a non-existing
"		    filespec will be opened, thereby creating a new file. 
"* RETURN VALUES: 
"   None. 
"******************************************************************************
    let l:bangArg = (a:hasBang ? '-bang' : '')

    execute printf('command! -bar %s -nargs=+ %sSubstitute call EditSimilar#OpenSubstitute(%s, %s, expand("%%:p"), <f-args>)',
    \   l:bangArg, a:commandPrefix, string(a:fileCommand), a:createNew)
    execute printf('command! -bar %s -count=0 %sNext       call EditSimilar#OpenOffset(%s, %s, expand("%%:p"), <count>,  1)',
    \   l:bangArg, a:commandPrefix, string(a:fileCommand), a:createNew)
    execute printf('command! -bar %s -count=0 %sPrevious   call EditSimilar#OpenOffset(%s, %s, expand("%%:p"), <count>,  -1)',
    \   l:bangArg, a:commandPrefix, string(a:fileCommand), a:createNew)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
