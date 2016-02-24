" Test read-only ViewSubstitute.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(11)
cd testdata

" Tests that substitution is performed multiple times (o=C).
" Tests that multiple substitutions are performed.
edit foobar.txt
call vimtap#Ok(! &l:readonly, 'Original is not readonly')
ViewSubstitute o=C bar=baz
call vimtap#file#IsFilename('fCCbaz.txt', 'foobar -> ViewSubstitute -> fCCbaz')
call vimtap#file#IsFile('foobar -> ViewSubstitute -> fCCbaz')
call vimtap#Ok(&l:readonly, 'ViewSubstitute is readonly')

" Tests simple substitution.
edit foobar.txt
call vimtap#Ok(! &l:readonly, 'Original is not readonly')
ViewRoot cpp
call vimtap#file#IsFilename('foobar.cpp', 'txt -> ViewRoot -> cpp')
call vimtap#file#IsFile('txt -> ViewRoot -> cpp')
call vimtap#Ok(&l:readonly, 'ViewRoot is readonly')

" Test SViewSubstitute on filename.
edit foobar.txt
call vimtap#Ok(! &l:readonly, 'Original is not readonly')
SViewSubstitute o=C bar=baz
call vimtap#Ok(&l:readonly, 'SViewSubstitute is readonly')
wincmd w
call vimtap#Ok(! &l:readonly, 'Original after SViewSubstitute is still not readonly')

call vimtest#Quit()
