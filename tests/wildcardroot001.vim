" Test EditRoot with file wildcards.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(12)
cd testdata

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
try
    EditRoot j*
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('Substituted file does not exist (add ! to create): foobar.j*', 'foobar.j* does not exist')
endtry
call vimtap#file#IsFilename('foobar.cpp', 'cpp -> EditRoot H> j*')

" Tests error that substituted file is the same.
edit foobar.txt
try
    EditRoot t?t
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('Nothing substituted', 'error')
endtry
call vimtap#file#IsFilename('foobar.txt', 'txt -> EditRoot H> t?t')

" Tests that bang creates file.
edit foobar.cpp
EditRoot! j*
if ingo#os#IsWindows()
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
