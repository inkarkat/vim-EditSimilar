" Test EditRoot.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(22)
cd testdata

" Tests simple substitution.
edit foobar.txt
EditRoot cpp
call vimtap#file#IsFilename('foobar.cpp', 'txt -> EditRoot -> cpp')
call vimtap#file#IsFile('txt -> EditRoot -> cpp')

" Tests substitution with a replacement starting with .
edit foobar.txt
EditRoot .cpp
call vimtap#file#IsFilename('foobar.cpp', 'txt -> EditRoot -> cpp')
call vimtap#file#IsFile('txt -> EditRoot -> cpp')

" Tests error that substituted extension does not exist.
edit foobar.cpp
call vimtap#err#Errors('Substituted file does not exist (add ! to create): foobar.java', 'EditRoot java', 'foobar.java does not exist')
call vimtap#file#IsFilename('foobar.cpp', 'cpp -> EditRoot H> java')

" Tests error that substituted file is the same.
edit foobar.txt
call vimtap#err#Errors('Nothing substituted', 'EditRoot txt', 'error')
call vimtap#file#IsFilename('foobar.txt', 'txt -> EditRoot H> txt')

" Tests that bang creates file.
edit foobar.cpp
EditRoot! java
call vimtap#file#IsFilename('foobar.java', 'cpp -> EditRoot! -> java')
call vimtap#file#IsNoFile('cpp -> EditRoot! -> java')

" Tests from no extension.
edit foobar
EditRoot cpp
call vimtap#file#IsFilename('foobar.cpp', '[] -> EditRoot -> cpp')
call vimtap#file#IsFile('[] -> EditRoot -> cpp')

" Tests to no extension.
edit foobar.txt
EditRoot .
call vimtap#file#IsFilename('foobar', 'txt -> EditRoot -> []')
call vimtap#file#IsFile('txt -> EditRoot -> []')

" Tests from double to no extension.
edit foobar.orig.txt
EditRoot ..
call vimtap#file#IsFilename('foobar', 'orig.txt -> EditRoot -> []')
call vimtap#file#IsFile('orig.txt -> EditRoot -> []')

" Tests from double extension, replacing last.
edit foobar.orig.txt
EditRoot! XXX
call vimtap#file#IsFilename('foobar.orig.XXX', 'orig.txt -> EditRoot! -> orig.XXX')
call vimtap#file#IsNoFile('orig.txt -> EditRoot! -> orig.XXX')

" Tests from double extension, replacing both.
edit foobar.orig.txt
EditRoot! ..YYY
call vimtap#file#IsFilename('foobar.YYY', 'orig.txt -> EditRoot! -> YYY')
call vimtap#file#IsNoFile('orig.txt -> EditRoot! -> YYY')

" Tests to double extension.
edit foobar.cpp
EditRoot orig.txt
call vimtap#file#IsFilename('foobar.orig.txt', 'cpp -> EditRoot -> orig.txt')
call vimtap#file#IsFile('cpp -> EditRoot -> orig.txt')

call vimtest#Quit()
