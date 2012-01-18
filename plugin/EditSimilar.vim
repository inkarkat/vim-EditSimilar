" EditSimilar.vim: Commands to edit files with a similar filename. 
"
" DEPENDENCIES:
"   - EditSimilar.vim autoload script. 
"   - EditSimilar/CommandBuilder.vim autoload script. 
"
" Copyright: (C) 2009-2011 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"   1.20.009	05-Nov-2011	ENH: Omit current buffer's file extension from
"				the completion for EditSimilar-root commands. 
"				Use
"				EditSimilar#CommandBuilder#SimilarFileOperations()
"				to create the :*Substitute, :*Next and
"				:*Previous commands. 
"				Obsolete the short command forms :Esubst,
"				:Enext, :Eprev; the starting uppercase letter
"				makes them still awkward to type, there's more
"				likely a conflict with other custom commands
"				(e.g. :En -> :Encode, :Enext), and I now believe
"				aliasing via cmdalias.vim is the better way to
"				provide personal shortcuts, instead of polluting
"				the command namespace with all these duplicates. 
"   1.18.008	22-Jun-2011	ENH: Implement completion of file extensions for
"				EditSimilar-root commands like :EditRoot. 
"   1.13.007	26-Jun-2009	:EditNext / :EditPrevious without the optional
"				[count] now skip over gaps in numbering. Changed
"				the default [count] to 0 to be able to detect a
"				given count. 
"   1.11.006	11-May-2009	Added commands to open similar files in
"				read-only mode, a la :ViewSubstitute,
"				:SViewSubstitute. 
"   1.00.005	18-Feb-2009	Reviewed for publication. 
"	004	04-Feb-2009	Full path '%:p' not needed for root commands. 
"	003	02-Feb-2009	Moved functions from plugin to separate autoload
"				script. 
"				Moved documentation to separate help file. 
"	002	31-Jan-2009	Moved :Sproot and :Sppattern commands from
"				ingocommands.vim. 
"				ENH: :Sppattern now notifies when no new windows
"				have been opened. 
"				Added overloads for :file, :write and :saveas. 
"				For the :edit, :split and :vsplit overloads,
"				there are now a long (:EditPrevious) and a short
"				(:Eprev) version. 
"	001	29-Jan-2009	file creation

" Avoid installing twice or when in unsupported VIM version. 
if exists('g:loaded_EditSimilar') || (v:version < 700)
    finish
endif
let g:loaded_EditSimilar = 1

let s:save_cpo = &cpo
set cpo&vim

" Substitute and Next / Previous commands. 
call EditSimilar#CommandBuilder#SimilarFileOperations('Edit', 'edit', 1, '<bang>0')
call EditSimilar#CommandBuilder#SimilarFileOperations('View', 'view', 1, '<bang>0')
call EditSimilar#CommandBuilder#SimilarFileOperations('Split', 'split', 1, '<bang>0')
call EditSimilar#CommandBuilder#SimilarFileOperations('VSplit', 'vsplit', 1, '<bang>0')
call EditSimilar#CommandBuilder#SimilarFileOperations('SView', 'sview', 1, '<bang>0')
call EditSimilar#CommandBuilder#SimilarFileOperations('File', 'file', 0, 1)
call EditSimilar#CommandBuilder#SimilarFileOperations('Write', 'write<bang>', 1, 1)
call EditSimilar#CommandBuilder#SimilarFileOperations('Save', 'saveas<bang>', 1, 1)


" Root (i.e. file extension) commands. 
function! s:RootComplete( ArgLead, CmdLine, CursorPos )
    return 
    \	filter(
    \	    map(
    \		split(
    \		    glob(expand('%:r') . '.' . a:ArgLead . '*'),
    \		    "\n"
    \		),
    \		'fnamemodify(v:val, ":e")'
    \	    ),
    \	    'v:val !=# ' . string(expand('%:e'))
    \	)
    " Note: No need for fnameescape(); the Root commands don't support Vim
    " special characters like % and # and therefore do the escaping themselves. 
endfunction
command! -bar -bang -nargs=1 -complete=customlist,<SID>RootComplete EditRoot     call EditSimilar#OpenRoot('edit',   <bang>0, expand('%'), <f-args>)
command! -bar -bang -nargs=1 -complete=customlist,<SID>RootComplete ViewRoot     call EditSimilar#OpenRoot('view',   <bang>0, expand('%'), <f-args>)
command! -bar -bang -nargs=1 -complete=customlist,<SID>RootComplete SplitRoot    call EditSimilar#OpenRoot('split',  <bang>0, expand('%'), <f-args>)
command! -bar -bang -nargs=1 -complete=customlist,<SID>RootComplete VSplitRoot   call EditSimilar#OpenRoot('vsplit', <bang>0, expand('%'), <f-args>)
command! -bar -bang -nargs=1 -complete=customlist,<SID>RootComplete SViewRoot    call EditSimilar#OpenRoot('sview',  <bang>0, expand('%'), <f-args>)
command! -bar       -nargs=1 -complete=customlist,<SID>RootComplete FileRoot     call EditSimilar#OpenRoot('file',         1, expand('%'), <f-args>)
command! -bar -bang -nargs=1 -complete=customlist,<SID>RootComplete WriteRoot    call EditSimilar#OpenRoot('write<bang>',  1, expand('%'), <f-args>)
command! -bar -bang -nargs=1 -complete=customlist,<SID>RootComplete SaveRoot     call EditSimilar#OpenRoot('saveas<bang>', 1, expand('%'), <f-args>)


" Pattern commands. 
" Note: We cannot use -complete=file; it results in E77: too many files error
" when using a pattern. 
command! -bar -nargs=1 SplitPattern    call EditSimilar#SplitPattern('split', <f-args>)
command! -bar -nargs=1 VSplitPattern   call EditSimilar#SplitPattern('vsplit', <f-args>)
command! -bar -nargs=1 SViewPattern    call EditSimilar#SplitPattern('sview', <f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
