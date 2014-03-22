" Test DiffSplitPattern.

call vimtest#StartTap()
call vimtap#Plan(4)
cd testdata

edit file003.txt

" Tests that multiple matches are opened.
DiffSplitPattern file*00.txt
call vimtap#window#IsWindows( reverse(['file003.txt', 'file20000.txt', 'file100.txt']), 'DiffSplitPattern file*00.txt')
windo call vimtap#Ok(&l:diff, 'diff enabled')

" Test no matches.
echomsg 'Test: no matches'
SplitPattern doesn?texist.*

call vimtest#Quit()
