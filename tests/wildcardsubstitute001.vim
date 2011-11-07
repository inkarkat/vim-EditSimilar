" Test EditSubstitute with file wildcards in the replacement part. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(17)

" Tests that the ? wildcard is recognized in the replacement part. 
edit foobar.txt
EditSubstitute foobar=l?l?
call vimtap#file#IsFilename('lala.txt', 'foobar -> EditSubstitute =? -> lala')
call vimtap#file#IsFile('foobar -> EditSubstitute =? -> lala')

" Tests that the * wildcard is recognized in the replacement part. 
edit foobar.txt
EditSubstitute foobar=l* txt=in*ll
call vimtap#file#IsFilename('lala.install', 'foobar.txt -> EditSubstitute =* -> lala.install')
call vimtap#file#IsFile('foobar.txt -> EditSubstitute =* -> lala.install')

" Tests that the ** wildcard is recognized in the replacement part. 
edit foobar.txt
EditSubstitute foobar=**/prod666
call vimtap#file#IsFilespec('001/production/prod666.txt', 'foobar.txt -> EditSubstitute =** -> 001/production/prod666')
call vimtap#file#IsFile('foobar.txt -> EditSubstitute =** -> 001/production/prod666')
execute 'cd' expand('<sfile>:p:h')

" Tests that the [ch] wildcard is recognized in the replacement part. 
edit foobar.txt
EditSubstitute oobar=i[lxy]e[abc123]00
call vimtap#file#IsFilename('file100.txt', 'foobar -> EditSubstitute =[] -> file100')
call vimtap#file#IsFile('foobar -> EditSubstitute =[] -> file100')

" Tests that the [^ch] wildcard is recognized in the replacement part. 
edit foobar.txt
EditSubstitute oobar=ile00[^3-7]
call vimtap#file#IsFilename('file009.txt', 'foobar -> EditSubstitute =[^] -> file009')
call vimtap#file#IsFile('foobar -> EditSubstitute =[^] -> file009')

" Tests that the [ch] wildcard is taken literally if such a file exists. 
" (This is Vim functionality.) 
edit file003.txt
EditSubstitute 003=[abc]
call vimtap#file#IsFilename('file[abc].txt', 'file003 -> EditSubstitute =[] -> file[abc]')
call vimtap#file#IsFile('file003 -> EditSubstitute =[] -> file[abc]')

" Tests error that substituted file pattern does not exist. 
edit foobar.txt
echomsg 'Test: fooz*.txt does not exist'
EditSubstitute bar=z*
call vimtap#file#IsFilename('foobar.txt', 'foobar -> EditSubstitute =* H> fooz*')

edit foobar.txt
echomsg 'Test: fi[XYZ]e[abc123].txt does not exist'
EditSubstitute oobar=i[XYZ]e[abc123]
call vimtap#file#IsFilename('foobar.txt', 'foobar -> EditSubstitute =[] H> fi[XYZ]e[abc123]')

" Tests error that substituted file pattern matches multiple files. 
edit lala.txt
echomsg 'Test: lala.des* matches multiple files.'
EditSubstitute txt=des*
call vimtap#file#IsFilename('lala.txt', 'foobar -> EditSubstitute =* H> .desc .description')

" Tests that bang creates file (on Unix, not possible on Windows). 
edit foobar.txt
EditSubstitute! bar=z*
if has('win32') || has('win64')
    call vimtap#file#IsFilename('foobar.txt', 'foobar -> EditSubstitute! =* H> fooz*')
    call vimtap#file#IsFile('foobar -> EditSubstitute! =* H> fooz*')
else
    call vimtap#file#IsFilename('fooz*.txt', 'foobar -> EditSubstitute! =* -> fooz*')
    call vimtap#file#IsNoFile('foobar -> EditSubstitute! =* -> fooz*')
endif

call vimtest#Quit()
