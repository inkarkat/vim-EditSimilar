" Test EditRoot with file wildcards. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(10)

" Tests that the ? wildcard is recognized. 
edit lala.txt
EditRoot d?sc
call vimtap#file#IsFilename('lala.desc', 'txt -> EditRoot -> d?sc')
call vimtap#file#IsFile('txt -> EditRoot -> d?sc')

" Tests that the * wildcard is recognized. 
edit lala.txt
EditRoot d*c
call vimtap#file#IsFilename('lala.desc', 'txt -> EditRoot -> d*c')
call vimtap#file#IsFile('txt -> EditRoot -> d*c')

" Tests error that substituted extension does not exist. 
edit foobar.cpp
echomsg 'Test: foobar.j* does not exist'
EditRoot j*
call vimtap#file#IsFilename('foobar.cpp', 'cpp -> EditRoot H> j*')

" Tests error that substituted file is the same. 
edit foobar.txt
echomsg 'Test: Nothing substituted'
EditRoot t?t
call vimtap#file#IsFilename('foobar.txt', 'txt -> EditRoot H> t?t')

" Tests that bang creates file. 
edit foobar.cpp
EditRoot! j*
if has('win32') || has('win64')
    call vimtap#file#IsFilename('foobar.cpp', 'cpp -> EditRoot! H> j*')
    call vimtap#file#IsFile('cpp -> EditRoot! H> j*')
else
    call vimtap#file#IsFilename('foobar.j*', 'cpp -> EditRoot! -> j*')
    call vimtap#file#IsNoFile('cpp -> EditRoot! -> j*')
endif

" Tests from no extension. 
edit foobar
EditRoot c??
call vimtap#file#IsFilename('foobar.cpp', '[] -> EditRoot -> c??')
call vimtap#file#IsFile('[] -> EditRoot -> c??')

call vimtest#Quit()
