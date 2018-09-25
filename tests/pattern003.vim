" Test SplitPattern with optional +cmd.
" Tests that all files are opened with the cmd applied.

call vimtest#StartTap()
call vimtap#Plan(2)
cd testdata

set nowrap
edit file100.txt

SplitPattern +setl\ wrap\|echomsg\ 'open'\ expand('\%') foobar*
call vimtap#window#IsWindows( reverse(['file100.txt', 'foobar.txt', 'foobar.orig.txt', 'foobar.cpp', 'foobar']), 'SplitPattern foobar*')
call vimtap#Is(&l:wrap, 1, 'wrap enabled')

call vimtest#Quit()
