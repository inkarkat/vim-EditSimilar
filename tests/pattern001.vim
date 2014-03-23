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
call vimtap#window#IsWindows( reverse(['file100.txt', 'foobar.txt', 'fXXbaz.txt']), 'SplitPattern f??b??.txt ')

" Tests addition of many new files to the existing.
SplitPattern foobar*
call vimtap#window#IsWindows( reverse(['file100.txt', 'foobar.txt', 'fXXbaz.txt', 'foobar.orig.txt', 'foobar.cpp', 'foobar']), 'SplitPattern foobar*')

" Test no new files.
echomsg 'Test: no new files'
SplitPattern foo*
call vimtap#window#IsWindows( reverse(['file100.txt', 'foobar.txt', 'fXXbaz.txt', 'foobar.orig.txt', 'foobar.cpp', 'foobar']), 'SplitPattern foobar*')

" Test no matches.
try
    SplitPattern doesn?texist.*
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('No matches', 'error')
endtry

call vimtest#Quit()
