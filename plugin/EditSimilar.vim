" EditSimilar.vim: Commands to edit files with a similar filename.
"
" DEPENDENCIES:
"   - EditSimilar.vim autoload script
"   - EditSimilar/CommandBuilder.vim autoload script
"   - EditSimilar/OverBuffer.vim autoload script
"   - EditSimilar/Pattern.vim autoload script
"   - ingo/err.vim autoload script
"
" Copyright: (C) 2009-2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_EditSimilar') || (v:version < 700)
    finish
endif
let g:loaded_EditSimilar = 1

if v:version < 702 | runtime autoload/ingo/cmdargs/file.vim | endif  " The Funcref doesn't trigger the autoload in older Vim versions.


"- configuration ---------------------------------------------------------------

if ! exists('g:EditSimilar_splitmode')
    let g:EditSimilar_splitmode = ''
endif
if ! exists('g:EditSimilar_vsplitmode')
    let g:EditSimilar_vsplitmode = ''
endif
if ! exists('g:EditSimilar_diffsplitmode')
    let g:EditSimilar_diffsplitmode = ''
endif



"- commands --------------------------------------------------------------------

" Supporting commands.
command! -bar -bang          -nargs=+ -complete=file  SaveOverBufferAs if ! EditSimilar#OverBuffer#Save('saveas<bang>', <bang>0, <q-args>) | echoerr ingo#err#Get() | endif
command! -bar -bang -range=% -nargs=+ -complete=file WriteOverBuffer   if ! EditSimilar#OverBuffer#Save('<line1>,<line2>write<bang>', <bang>0, <q-args>) | echoerr ingo#err#Get() | endif


" Substitute, Plus / Minus, and Next / Previous commands.
" Root (i.e. file extension) commands.
call EditSimilar#CommandBuilder#SimilarFileOperations('Edit',           'edit',                                           1, '<bang>0', {'omitOperationsWorkingOnlyOnExistingFiles': 0, 'completeAnyRoot': 0, 'OptionParser': function('ingo#cmdargs#file#FilterFileOptionsAndCommandsToEscaped')})
call EditSimilar#CommandBuilder#SimilarFileOperations('View',           'view',                                           1, '<bang>0', {'omitOperationsWorkingOnlyOnExistingFiles': 0, 'completeAnyRoot': 0, 'OptionParser': function('ingo#cmdargs#file#FilterFileOptionsAndCommandsToEscaped')})
call EditSimilar#CommandBuilder#SimilarFileOperations('Split',          join([g:EditSimilar_splitmode, 'split']),         1, '<bang>0', {'omitOperationsWorkingOnlyOnExistingFiles': 0, 'completeAnyRoot': 0, 'OptionParser': function('ingo#cmdargs#file#FilterFileOptionsAndCommandsToEscaped')})
call EditSimilar#CommandBuilder#SimilarFileOperations('VSplit',         join([g:EditSimilar_vsplitmode, 'vsplit']),       1, '<bang>0', {'omitOperationsWorkingOnlyOnExistingFiles': 0, 'completeAnyRoot': 0, 'OptionParser': function('ingo#cmdargs#file#FilterFileOptionsAndCommandsToEscaped')})
call EditSimilar#CommandBuilder#SimilarFileOperations('SView',          join([g:EditSimilar_splitmode, 'sview']),         1, '<bang>0', {'omitOperationsWorkingOnlyOnExistingFiles': 0, 'completeAnyRoot': 0, 'OptionParser': function('ingo#cmdargs#file#FilterFileOptionsAndCommandsToEscaped')})
call EditSimilar#CommandBuilder#SimilarFileOperations('DiffSplit',      join([g:EditSimilar_diffsplitmode, 'diffsplit']), 1, '<bang>0', {'omitOperationsWorkingOnlyOnExistingFiles': 0, 'completeAnyRoot': 0})
call EditSimilar#CommandBuilder#SimilarFileOperations('File',           'file',                                           0, 1,         {'omitOperationsWorkingOnlyOnExistingFiles': 1, 'completeAnyRoot': 1})
call EditSimilar#CommandBuilder#SimilarFileOperations('Write',          '<line1>,<line2>WriteOverBuffer<bang>',           1, 1,         {'omitOperationsWorkingOnlyOnExistingFiles': 1, 'completeAnyRoot': 1, 'OptionParser': function('ingo#cmdargs#file#FilterFileOptionsToEscaped'), 'isSupportRange': 1})
call EditSimilar#CommandBuilder#SimilarFileOperations('Save',           'SaveOverBufferAs<bang>',                         1, 1,         {'omitOperationsWorkingOnlyOnExistingFiles': 1, 'completeAnyRoot': 1, 'OptionParser': function('ingo#cmdargs#file#FilterFileOptionsToEscaped')})
call EditSimilar#CommandBuilder#SimilarFileOperations('BDelete',        'bdelete<bang>',                                  1, 1,         {'omitOperationsWorkingOnlyOnExistingFiles': 0, 'completeAnyRoot': 0})


" Pattern commands.
" Note: Must use + instead of 1; otherwise (due to -complete=file), Vim
" complains about globs with "E77: Too many file names".
command! -bar -nargs=+ -complete=file SplitPattern      if ! EditSimilar#Pattern#Split(join([g:EditSimilar_splitmode, 'split']), function('ingo#cmdargs#file#FilterFileOptionsAndCommandsToEscaped'),        <q-args>, 1) | echoerr ingo#err#Get() | endif
command! -bar -nargs=+ -complete=file VSplitPattern     if ! EditSimilar#Pattern#Split(join([g:EditSimilar_vsplitmode, 'vsplit']), function('ingo#cmdargs#file#FilterFileOptionsAndCommandsToEscaped'),      <q-args>, 1) | echoerr ingo#err#Get() | endif
command! -bar -nargs=+ -complete=file SViewPattern      if ! EditSimilar#Pattern#Split(join([g:EditSimilar_splitmode, 'sview']), function('ingo#cmdargs#file#FilterFileOptionsAndCommandsToEscaped'),        <q-args>, 1) | echoerr ingo#err#Get() | endif
command! -bar -nargs=+ -complete=file DiffSplitPattern  if ! EditSimilar#Pattern#Split(join([g:EditSimilar_diffsplitmode, 'diffsplit']), '',                                                  <q-args>, 1) | echoerr ingo#err#Get() | endif
command! -bar -bang -nargs=+ -complete=file BDeletePattern if ! EditSimilar#Pattern#Split('silent! bdelete<bang>', '', <q-args>, 0) | echoerr ingo#err#Get() | endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
