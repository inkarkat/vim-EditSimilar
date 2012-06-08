" EditSimilar/CommandBuilder.vim: Utility for creating EditSimilar commands.
"
" DEPENDENCIES:
"   - EditSimilar/Next.vim autoload script
"   - EditSimilar/Offset.vim autoload script
"   - EditSimilar/Root.vim autoload script
"   - EditSimilar/Substitute.vim autoload script
"
" Copyright: (C) 2011-2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   2.00.004	09-Jun-2012	Rename the *Next / *Previous commands to *Plus /
"				*Minus and redefine them to operate on directory
"				contents instead of numerical offsets.
"   			    	Move all similarity implementations to separate
"				modules.
"   1.21.003	19-Jan-2012	Create the root commands also in the command
"				builder.
"   1.20.002	08-Nov-2011	Add documentation.
"	001	05-Nov-2011	file creation
let s:save_cpo = &cpo
set cpo&vim

function! EditSimilar#CommandBuilder#SimilarFileOperations( commandPrefix, fileCommand, hasBang, createNew )
"******************************************************************************
"* PURPOSE:
"   Create *Plus, *Minus, *Next, *Previous, *Substitute and *Root commands with
"   * = a:commandPrefix for a:fileCommand.
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

    execute printf('command! -bar %s -nargs=+ %sSubstitute call EditSimilar#Substitute#Open(%s, %s, expand("%%:p"), <f-args>)',
    \   l:bangArg, a:commandPrefix, string(a:fileCommand), a:createNew)
    execute printf('command! -bar %s -count=0 %sPlus       call EditSimilar#Offset#Open(%s, %s, expand("%%:p"), <count>,  1)',
    \   l:bangArg, a:commandPrefix, string(a:fileCommand), a:createNew)
    execute printf('command! -bar %s -count=0 %sMinus      call EditSimilar#Offset#Open(%s, %s, expand("%%:p"), <count>,  -1)',
    \   l:bangArg, a:commandPrefix, string(a:fileCommand), a:createNew)
    execute printf('command! -bar %s -count=0 %sNext       call EditSimilar#Next#Open(%s, %s, expand("%%:p"), <count>,  1)',
    \   l:bangArg, a:commandPrefix, string(a:fileCommand), a:createNew)
    execute printf('command! -bar %s -count=0 %sPrevious   call EditSimilar#Next#Open(%s, %s, expand("%%:p"), <count>,  -1)',
    \   l:bangArg, a:commandPrefix, string(a:fileCommand), a:createNew)
    execute printf('command! -bar %s -nargs=1 -complete=customlist,EditSimilar#Root#Complete ' .
    \                                        '%sRoot       call EditSimilar#Root#Open(%s, %s, expand("%%"), <f-args>)',
    \   l:bangArg, a:commandPrefix, string(a:fileCommand), a:createNew)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
