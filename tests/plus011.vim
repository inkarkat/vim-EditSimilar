" Test FileMinus at the lower border.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(6)
cd testdata

" Tests forced boundary of 1 (not 0).
edit file007.txt
9FileMinus!
call IsNumAndNoFile(1, '9FileMinus!')

" Tests decrease to existing 1.
edit 001/dev/dev002.txt
FileMinus
call vimtap#file#IsFilespec('001/dev/dev001.txt', 'FileMinus on 002')

" Tests decrease to non-existing 0.
edit 001/dev/dev001.txt
FileMinus
call vimtap#file#IsFilespec('001/dev/dev000.txt', 'FileMinus on 001')

" Tests no further decrease on 0.
try
    FileMinus
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('Nothing substituted', 'error')
endtry
call vimtap#file#IsFilespec('001/dev/dev000.txt', 'FileMinus on 000')

call vimtest#Quit()
