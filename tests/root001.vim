" Test Eroot. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(20)

" Tests simple substitution. 
edit foobar.txt
Eroot cpp
call vimtap#file#IsFilename('foobar.cpp', 'txt -> Eroot -> cpp')
call vimtap#file#IsFile('txt -> Eroot -> cpp')

" Tests substitution with a replacement starting with .
edit foobar.txt
Eroot .cpp
call vimtap#file#IsFilename('foobar.cpp', 'txt -> Eroot -> cpp')
call vimtap#file#IsFile('txt -> Eroot -> cpp')

" Tests error that substituted extension does not exist. 
edit foobar.cpp
echomsg 'Test: foobar.java does not exist'
Eroot java
call vimtap#file#IsFilename('foobar.cpp', 'cpp -> Eroot H> java')

" Tests error that substituted file is the same. 
edit foobar.txt
echomsg 'Test: Nothing substituted'
Eroot txt
call vimtap#file#IsFilename('foobar.txt', 'txt -> Eroot H> txt')

" Tests that bang creates file. 
edit foobar.cpp
Eroot! java
call vimtap#file#IsFilename('foobar.java', 'cpp -> Eroot! -> java')
call vimtap#file#IsNoFile('cpp -> Eroot! -> java')

" Tests from no extension. 
edit foobar
Eroot cpp
call vimtap#file#IsFilename('foobar.cpp', '[] -> Eroot -> cpp')
call vimtap#file#IsFile('[] -> Eroot -> cpp')

" Tests to no extension. 
edit foobar.txt
Eroot .
call vimtap#file#IsFilename('foobar', 'txt -> Eroot -> []')
call vimtap#file#IsFile('txt -> Eroot -> []')

" Tests from double to no extension. 
edit foobar.orig.txt
Eroot ..
call vimtap#file#IsFilename('foobar', 'orig.txt -> Eroot -> []')
call vimtap#file#IsFile('orig.txt -> Eroot -> []')

" Tests from double extension, replacing last. 
edit foobar.orig.txt
Eroot! XXX
call vimtap#file#IsFilename('foobar.orig.XXX', 'orig.txt -> Eroot! -> orig.XXX')
call vimtap#file#IsNoFile('orig.txt -> Eroot! -> orig.XXX')

" Tests from double extension, replacing both. 
edit foobar.orig.txt
Eroot! ..YYY
call vimtap#file#IsFilename('foobar.YYY', 'orig.txt -> Eroot! -> YYY')
call vimtap#file#IsNoFile('orig.txt -> Eroot! -> YYY')

" Tests to double extension. 
edit foobar.cpp
Eroot orig.txt
call vimtap#file#IsFilename('foobar.orig.txt', 'cpp -> Eroot -> orig.txt')
call vimtap#file#IsFile('cpp -> Eroot -> orig.txt')

call vimtest#Quit()

