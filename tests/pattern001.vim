" Test Sppat. 

call vimtest#StartTap()
call vimtap#Plan(4)

edit file100.txt

" Tests that a single match is opened. 
Sppat foobar.txt
call vimtap#window#IsWindows( reverse(['file100.txt', 'foobar.txt']), 'Sppat foobar.txt ')

" Tests addition of one new file to one existing. 
Sppat f??b??.txt
call vimtap#window#IsWindows( reverse(['file100.txt', 'foobar.txt', 'fXXbaz.txt']), 'Sppat f??b??.txt ')

" Tests addition of many new files to the existing. 
Sppat foobar*
call vimtap#window#IsWindows( reverse(['file100.txt', 'foobar.txt', 'fXXbaz.txt', 'foobar.orig.txt', 'foobar.cpp', 'foobar']), 'Sppat foobar*')

" Test no new files. 
echomsg 'Test: no new files'
Sppat foo*
call vimtap#window#IsWindows( reverse(['file100.txt', 'foobar.txt', 'fXXbaz.txt', 'foobar.orig.txt', 'foobar.cpp', 'foobar']), 'Sppat foobar*')

" Test no matches. 
echomsg 'Test: no matches'
Sppat doesn?texist.*

call vimtest#Quit()

