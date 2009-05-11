" Test Esubst with file wildcards in the replacement part. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(15)

" Tests that the ? wildcard is recognized in the replacement part. 
edit foobar.txt
Esubst foobar=l?l?
call vimtap#file#IsFilename('lala.txt', 'foobar -> Esubst =? -> lala')
call vimtap#file#IsFile('foobar -> Esubst =? -> lala')

" Tests that the * wildcard is recognized in the replacement part. 
edit foobar.txt
Esubst foobar=l* txt=in*ll
call vimtap#file#IsFilename('lala.install', 'foobar.txt -> Esubst =* -> lala.install')
call vimtap#file#IsFile('foobar.txt -> Esubst =* -> lala.install')

" Tests that the [ch] wildcard is recognized in the replacement part. 
edit foobar.txt
Esubst oobar=i[lxy]e[abc123]00
call vimtap#file#IsFilename('file100.txt', 'foobar -> Esubst =[] -> file100')
call vimtap#file#IsFile('foobar -> Esubst =[] -> file100')

" Tests that the [^ch] wildcard is recognized in the replacement part. 
edit foobar.txt
Esubst oobar=ile00[^3-7]
call vimtap#file#IsFilename('file009.txt', 'foobar -> Esubst =[^] -> file009')
call vimtap#file#IsFile('foobar -> Esubst =[^] -> file009')

" Tests that the [ch] wildcard is taken literally if such a file exists. 
" (This is Vim functionality.) 
edit file003.txt
Esubst 003=[abc]
call vimtap#file#IsFilename('file[abc].txt', 'file003 -> Esubst =[] -> file[abc]')
call vimtap#file#IsFile('file003 -> Esubst =[] -> file[abc]')

" Tests error that substituted file pattern does not exist. 
edit foobar.txt
echomsg 'Test: fooz*.txt does not exist'
Esubst bar=z*
call vimtap#file#IsFilename('foobar.txt', 'foobar -> Esubst =* H> fooz*')

edit foobar.txt
echomsg 'Test: fi[XYZ]e[abc123].txt does not exist'
Esubst oobar=i[XYZ]e[abc123]
call vimtap#file#IsFilename('foobar.txt', 'foobar -> Esubst =[] H> fi[XYZ]e[abc123]')

" Tests error that substituted file pattern matches multiple files. 
edit lala.txt
echomsg 'Test: lala.des* matches multiple files.'
Esubst txt=des*
call vimtap#file#IsFilename('lala.txt', 'foobar -> Esubst =* H> .desc .description')

" Tests that bang creates file (on Unix, not possible on Windows). 
edit foobar.txt
Esubst! bar=z*
if has('win32') || has('win64')
    call vimtap#file#IsFilename('foobar.txt', 'foobar -> Esubst! =* H> fooz*')
    call vimtap#file#IsFile('foobar -> Esubst! =* H> fooz*')
else
    call vimtap#file#IsFilename('fooz*.txt', 'foobar -> Esubst! =* -> fooz*')
    call vimtap#file#IsNoFile('foobar -> Esubst! =* -> fooz*')
endif

call vimtest#Quit()

