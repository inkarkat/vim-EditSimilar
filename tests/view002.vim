" Test read-only Vsubst. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(11)

" Tests that substitution is performed multiple times (o=X). 
" Tests that multiple substitutions are performed. 
edit foobar.txt
call vimtap#Ok(! &l:readonly, 'Original is not readonly')
Vsubst o=X bar=baz
call vimtap#file#IsFilename('fXXbaz.txt', 'foobar -> Vsubst -> fXXbaz')
call vimtap#file#IsFile('foobar -> Vsubst -> fXXbaz')
call vimtap#Ok(&l:readonly, 'Vsubst is readonly')

" Tests simple substitution. 
edit foobar.txt
call vimtap#Ok(! &l:readonly, 'Original is not readonly')
Vroot cpp
call vimtap#file#IsFilename('foobar.cpp', 'txt -> Vroot -> cpp')
call vimtap#file#IsFile('txt -> Vroot -> cpp') 
call vimtap#Ok(&l:readonly, 'Vroot is readonly')
 
" Test Svsubst on filename. 
edit foobar.txt
call vimtap#Ok(! &l:readonly, 'Original is not readonly')
Svsubst o=X bar=baz 
call vimtap#Ok(&l:readonly, 'Svsubst is readonly')
wincmd w
call vimtap#Ok(! &l:readonly, 'Original after Svsubst is still not readonly')

call vimtest#Quit()

