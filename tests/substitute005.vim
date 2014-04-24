" Test SplitSubstitute on filename.

call vimtest#StartTap()
call vimtap#Plan(1)
cd testdata

edit foobar.txt
SplitSubstitute o=X bar=baz
SplitSubstitute! X=00 z=k
call vimtap#window#IsWindows( reverse(['foobar.txt', 'fXXbaz.txt', 'f0000bak.txt']), 'SplitSubstitute foo files')

call vimtest#Quit()
