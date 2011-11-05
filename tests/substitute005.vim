" Test Spsubst on filename. 

call vimtest#StartTap()
call vimtap#Plan(1)

edit foobar.txt
Spsubst o=X bar=baz
Spsubst! X=00 z=k
call vimtap#window#IsWindows( reverse(['foobar.txt', 'fXXbaz.txt', 'f0000bak.txt']), 'Spsubst foo files')

call vimtest#Quit()

