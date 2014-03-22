" Test FileMinus at the lower border.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(5)
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
echomsg 'Test: Nothing substituted'
FileMinus
call vimtap#file#IsFilespec('001/dev/dev000.txt', 'FileMinus on 000')

call vimtest#Quit()
