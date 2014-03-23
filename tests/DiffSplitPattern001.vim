" Test DiffSplitPattern.

call vimtest#StartTap()
call vimtap#Plan(5)
cd testdata

edit file003.txt

" Tests that multiple matches are opened.
DiffSplitPattern file*00.txt
call vimtap#window#IsWindows( reverse(['file003.txt', 'file20000.txt', 'file100.txt']), 'DiffSplitPattern file*00.txt')
windo call vimtap#Ok(&l:diff, 'diff enabled')

try
    SplitPattern doesn?texist.*
catch
    call vimtap#err#Thrown('No matches', 'error')
endtry

call vimtest#Quit()
