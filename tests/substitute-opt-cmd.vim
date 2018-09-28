" Test EditSubstitute with options and +cmd.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(4)
cd testdata

set nobinary nowrap wrapmargin=0
edit foobar.txt

EditSubstitute ++bin ++bad=drop +setl\ wrap\|echomsg\ 'open'\ expand('%') o=C bar=baz
call IsNameAndFile('fCCbaz.txt', 'EditSubstitute .. o=C bar=baz')
call vimtap#Is(&l:wrap, 1, 'wrap enabled')
call vimtap#Is(&l:binary, 1, 'binary enabled')

call vimtest#Quit()
