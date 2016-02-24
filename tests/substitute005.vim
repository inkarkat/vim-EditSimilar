" Test SplitSubstitute on filename.

call vimtest#StartTap()
call vimtap#Plan(1)
cd testdata

edit foobar.txt
SplitSubstitute o=C bar=baz
SplitSubstitute! C=00 z=k
call vimtap#window#IsWindows( reverse(['foobar.txt', 'fCCbaz.txt', 'f0000bak.txt']), 'SplitSubstitute foo files')

call vimtest#Quit()
