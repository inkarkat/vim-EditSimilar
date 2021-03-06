" Test SplitPattern.

call vimtest#StartTap()
call vimtap#Plan(5)
cd testdata

edit file100.txt

" Tests that a single match is opened.
SplitPattern foobar.txt
call vimtap#window#IsWindows( reverse(['file100.txt', 'foobar.txt']), 'SplitPattern foobar.txt ')

" Tests addition of one new file to one existing.
SplitPattern f??b??.txt
call vimtap#window#IsWindows( reverse(['file100.txt', 'foobar.txt', 'fCCbaz.txt']), 'SplitPattern f??b??.txt ')

" Tests addition of many new files to the existing.
SplitPattern foobar*
call vimtap#window#IsWindows( reverse(['file100.txt', 'foobar.txt', 'fCCbaz.txt', 'foobar.orig.txt', 'foobar.cpp', 'foobar']), 'SplitPattern foobar*')

" Test no new files.
echomsg 'Test: no new files'
SplitPattern foo*
call vimtap#window#IsWindows( reverse(['file100.txt', 'foobar.txt', 'fCCbaz.txt', 'foobar.orig.txt', 'foobar.cpp', 'foobar']), 'SplitPattern foobar*')

" Test no matches.
call vimtap#err#Errors('No matches', 'SplitPattern doesn?texist.*', 'error')

call vimtest#Quit()
