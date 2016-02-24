" Test split configuration with pattern.

let g:EditSimilar_splitmode = 'belowright'
runtime plugin/EditSimilar.vim

call vimtest#StartTap()
call vimtap#Plan(1)
cd testdata

edit file100.txt
SplitPattern foobar*
call vimtap#window#IsWindows(['file100.txt', 'foobar', 'foobar.cpp', 'foobar.orig.txt', 'foobar.txt'], 'belowright SplitPattern foobar*')

call vimtest#Quit()
