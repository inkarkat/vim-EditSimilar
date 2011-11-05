" Test Eroot with file wildcards. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(10)

" Tests that the ? wildcard is recognized. 
edit lala.txt
Eroot d?sc
call vimtap#file#IsFilename('lala.desc', 'txt -> Eroot -> d?sc')
call vimtap#file#IsFile('txt -> Eroot -> d?sc')

" Tests that the * wildcard is recognized. 
edit lala.txt
Eroot d*c
call vimtap#file#IsFilename('lala.desc', 'txt -> Eroot -> d*c')
call vimtap#file#IsFile('txt -> Eroot -> d*c')

" Tests error that substituted extension does not exist. 
edit foobar.cpp
echomsg 'Test: foobar.j* does not exist'
Eroot j*
call vimtap#file#IsFilename('foobar.cpp', 'cpp -> Eroot H> j*')

" Tests error that substituted file is the same. 
edit foobar.txt
echomsg 'Test: Nothing substituted'
Eroot t?t
call vimtap#file#IsFilename('foobar.txt', 'txt -> Eroot H> t?t')

" Tests that bang creates file. 
edit foobar.cpp
Eroot! j*
if has('win32') || has('win64')
    call vimtap#file#IsFilename('foobar.cpp', 'cpp -> Eroot! H> j*')
    call vimtap#file#IsFile('cpp -> Eroot! H> j*')
else
    call vimtap#file#IsFilename('foobar.j*', 'cpp -> Eroot! -> j*')
    call vimtap#file#IsNoFile('cpp -> Eroot! -> j*')
endif

" Tests from no extension. 
edit foobar
Eroot c??
call vimtap#file#IsFilename('foobar.cpp', '[] -> Eroot -> c??')
call vimtap#file#IsFile('[] -> Eroot -> c??')

call vimtest#Quit()

