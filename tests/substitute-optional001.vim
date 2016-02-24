" Test EditSubstitute with optional pairs.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(6)
execute 'cd' expand('<sfile>:p:h') . '/testdata'

edit foobar.txt
EditSubstitute o=C bar=?baz
call vimtap#file#IsFilename('fCCbaz.txt', 'foobar -> EditSubstitute = =? -> fCCbaz')
call vimtap#file#IsFile('foobar -> EditSubstitute -> fCCbaz')

edit foobar.txt
call vimtap#err#Errors('Nothing non-optional substituted', 'EditSubstitute o=?C nono=never bar=?baz', 'error')
call vimtap#err#Errors('Nothing non-optional substituted', 'EditSubstitute! o=?C nono=never bar=?baz', 'error')
call vimtap#err#Errors('Nothing non-optional substituted', 'EditSubstitute o=?C bar=?baz', 'error')
call vimtap#err#Errors('Nothing substituted', 'EditSubstitute y=z N=X', 'error')

call vimtest#Quit()
