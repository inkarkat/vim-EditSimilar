" Test EditSubstitute with path separators.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(10)
cd testdata

" Tests replacement with forward slashes as path separators.
execute 'cd' expand('<sfile>:p:h') . '/testdata'
edit 001/prod/prod001.txt
EditSubstitute prod001=dev002 1/prod/=1/dev/
call vimtap#file#IsFilespec('001/dev/dev002.txt', '001/prod/prod001 -> EditSubstitute //= -> 001/dev/dev002')
call vimtap#file#IsFile('001/prod/prod001 -> EditSubstitute //= -> 001/dev/dev002')

if ! vimtap#Skip(2, ingo#os#IsWindows(), 'need Windows')
    " Tests replacement with native path separators.
    execute 'cd' expand('<sfile>:p:h') . '/testdata'
    edit 001/prod/prod001.txt
    EditSubstitute prod001=dev002 1\prod\=1\dev\
    call vimtap#file#IsFilespec('001/dev/dev002.txt', '001/prod/prod001 -> EditSubstitute \\= -> 001/dev/dev002')
    call vimtap#file#IsFile('001/prod/prod001 -> EditSubstitute \\= -> 001/dev/dev002')
endif

" Tests text with forward slashes as path separators.
execute 'cd' expand('<sfile>:p:h') . '/testdata'
edit file001.txt
EditSubstitute file=001/prod/prod
call vimtap#file#IsFilespec('001/prod/prod001.txt', 'file001 -> EditSubstitute =// -> 001/prod/prod001')
call vimtap#file#IsFile('file001 -> EditSubstitute =// -> 001/prod/prod001')

if ! vimtap#Skip(2, ingo#os#IsWindows(), 'need Windows')
"   Tests text with native path separators.
    execute 'cd' expand('<sfile>:p:h') . '/testdata'
    edit file001.txt
    EditSubstitute file=001\prod\prod
    call vimtap#file#IsFilespec('001/prod/prod001.txt', 'file001 -> EditSubstitute =\\ -> 001/prod/prod001')
    call vimtap#file#IsFile('file001 -> EditSubstitute =\\ -> 001/prod/prod001')
endif

" Tests replacement across pathspec / filename.
execute 'cd' expand('<sfile>:p:h') . '/testdata'
edit 001/prod/prod001.txt
EditSubstitute prod/prod=dev/dev
call vimtap#file#IsFilespec('001/dev/dev001.txt', '001/prod/prod001 -> EditSubstitute /=/ -> 001/dev/dev001')
call vimtap#file#IsFile('001/prod/prod001 -> EditSubstitute /=/ -> 001/dev/dev001')

call vimtest#Quit()
