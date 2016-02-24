" Test SplitPattern with multiple arguments.
" Tests that files resulting from multiple pattern are opened only once.

call vimtest#StartTap()
call vimtap#Plan(1)
cd testdata

edit file100.txt

SplitPattern *a*.txt lala.*
call vimtap#window#IsWindows( (['fCCbaz.txt', 'file[abc].txt', 'fino[^abc].txt', 'foobar.orig.txt', 'foobar.txt', 'lala.txt', 'lala.desc', 'lala.description', 'lala.install', 'file100.txt']), 'SplitPattern *a*.txt lala.*')

call vimtest#Quit()
